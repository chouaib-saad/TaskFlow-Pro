/*
  # Initial Schema Setup for TaskFlow Pro

  1. Tables
    - profiles
      - id (uuid, references auth.users)
      - full_name (text)
      - role (enum: admin, manager, developer)
      - avatar_url (text)
      - updated_at (timestamp)
    
    - projects
      - id (uuid)
      - name (text)
      - description (text)
      - status (text)
      - start_date (timestamp)
      - end_date (timestamp)
      - created_at (timestamp)
      - updated_at (timestamp)
    
    - tasks
      - id (uuid)
      - title (text)
      - description (text)
      - status (enum: todo, in_progress, review, done)
      - priority (enum: low, medium, high, urgent)
      - due_date (timestamp)
      - project_id (uuid, references projects)
      - assigned_to (uuid, references profiles)
      - created_by (uuid, references profiles)
      - created_at (timestamp)
      - updated_at (timestamp)
    
    - project_members
      - project_id (uuid, references projects)
      - profile_id (uuid, references profiles)
      - role (text)
      - joined_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for each table
*/

-- Create custom types
CREATE TYPE user_role AS ENUM ('admin', 'manager', 'developer');
CREATE TYPE task_status AS ENUM ('todo', 'in_progress', 'review', 'done');
CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high', 'urgent');

-- Create profiles table
CREATE TABLE profiles (
  id uuid REFERENCES auth.users ON DELETE CASCADE,
  full_name text,
  role user_role DEFAULT 'developer',
  avatar_url text,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  PRIMARY KEY (id)
);

-- Create projects table
CREATE TABLE projects (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'active',
  start_date timestamp with time zone DEFAULT now(),
  end_date timestamp with time zone,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create tasks table
CREATE TABLE tasks (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL,
  description text,
  status task_status DEFAULT 'todo',
  priority task_priority DEFAULT 'medium',
  due_date timestamp with time zone,
  project_id uuid REFERENCES projects ON DELETE CASCADE,
  assigned_to uuid REFERENCES profiles ON DELETE SET NULL,
  created_by uuid REFERENCES profiles ON DELETE SET NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create project_members table
CREATE TABLE project_members (
  project_id uuid REFERENCES projects ON DELETE CASCADE,
  profile_id uuid REFERENCES profiles ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'member',
  joined_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  PRIMARY KEY (project_id, profile_id)
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_members ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Projects policies
CREATE POLICY "Project members can view projects"
  ON projects FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM project_members
      WHERE project_id = id
      AND profile_id = auth.uid()
    )
  );

CREATE POLICY "Managers and admins can create projects"
  ON projects FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role IN ('manager', 'admin')
    )
  );

CREATE POLICY "Project managers and admins can update projects"
  ON projects FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role IN ('manager', 'admin')
    )
  );

-- Tasks policies
CREATE POLICY "Project members can view tasks"
  ON tasks FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM project_members
      WHERE project_id = tasks.project_id
      AND profile_id = auth.uid()
    )
  );

CREATE POLICY "Project members can create tasks"
  ON tasks FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM project_members
      WHERE project_id = NEW.project_id
      AND profile_id = auth.uid()
    )
  );

CREATE POLICY "Task assignee and project managers can update tasks"
  ON tasks FOR UPDATE
  USING (
    auth.uid() = assigned_to
    OR EXISTS (
      SELECT 1 FROM project_members pm
      JOIN profiles p ON p.id = pm.profile_id
      WHERE pm.project_id = tasks.project_id
      AND pm.profile_id = auth.uid()
      AND p.role IN ('manager', 'admin')
    )
  );

-- Project members policies
CREATE POLICY "Project members are viewable by other members"
  ON project_members FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM project_members
      WHERE project_id = project_members.project_id
      AND profile_id = auth.uid()
    )
  );

CREATE POLICY "Managers and admins can manage project members"
  ON project_members FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role IN ('manager', 'admin')
    )
  );

-- Create functions and triggers
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();
import { create } from "zustand";
import { Task, Project, User } from "@prisma/client";

interface AppState {
  tasks: Task[];
  projects: Project[];
  currentUser: User | null;
  setTasks: (tasks: Task[]) => void;
  setProjects: (projects: Project[]) => void;
  setCurrentUser: (user: User | null) => void;
  addTask: (task: Task) => void;
  updateTask: (taskId: string, updates: Partial<Task>) => void;
  deleteTask: (taskId: string) => void;
  addProject: (project: Project) => void;
  updateProject: (projectId: string, updates: Partial<Project>) => void;
  deleteProject: (projectId: string) => void;
}

export const useStore = create<AppState>((set) => ({
  tasks: [],
  projects: [],
  currentUser: null,
  setTasks: (tasks) => set({ tasks }),
  setProjects: (projects) => set({ projects }),
  setCurrentUser: (user) => set({ currentUser: user }),
  addTask: (task) => set((state) => ({ tasks: [...state.tasks, task] })),
  updateTask: (taskId, updates) =>
    set((state) => ({
      tasks: state.tasks.map((task) =>
        task.id === taskId ? { ...task, ...updates } : task
      ),
    })),
  deleteTask: (taskId) =>
    set((state) => ({
      tasks: state.tasks.filter((task) => task.id !== taskId),
    })),
  addProject: (project) =>
    set((state) => ({ projects: [...state.projects, project] })),
  updateProject: (projectId, updates) =>
    set((state) => ({
      projects: state.projects.map((project) =>
        project.id === projectId ? { ...project, ...updates } : project
      ),
    })),
  deleteProject: (projectId) =>
    set((state) => ({
      projects: state.projects.filter((project) => project.id !== projectId),
    })),
}));
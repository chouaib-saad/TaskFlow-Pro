# TaskFlow Pro

## Overview

TaskFlow Pro is a comprehensive, full-stack task management application designed to streamline project and task organization for individuals and teams. This project serves as an academic endeavor to demonstrate proficiency in modern web development technologies, focusing on building scalable, secure, and user-friendly applications. Developed as a self-learning initiative, it showcases best practices in full-stack development, including authentication, database management, and responsive UI design.

The application enables users to create and manage projects, assign tasks with varying priorities and deadlines, and track progress through an intuitive dashboard. It incorporates role-based access control to support different user levels (Admin, Manager, Developer), ensuring secure and efficient workflows.

## Key Features

- **User Authentication and Authorization**: Secure login and registration system powered by Supabase Auth, with support for email/password authentication. Role-based access control (Admin, Manager, Developer) to manage permissions and data visibility.
- **Project Management**: Create, edit, and delete projects with detailed descriptions, start/end dates, and status tracking. Assign team members to projects for collaborative work.
- **Task Management**: Comprehensive task creation with titles, descriptions, priorities (Low, Medium, High, Urgent), statuses (To Do, In Progress, Review, Done), and due dates. Assign tasks to specific users and link them to projects.
- **Responsive Dashboard**: A clean, mobile-friendly interface providing an overview of projects, tasks, and progress. Includes navigation menus, search functionality, and real-time updates.
- **Data Integrity and Security**: Utilizes Prisma ORM for type-safe database interactions with PostgreSQL. Implements secure data handling, input validation, and protection against common vulnerabilities.
- **Scalable Architecture**: Built with Next.js for server-side rendering and optimal performance. Modular component structure using shadcn/ui for consistent UI elements.
- **Real-time Capabilities**: Leverages Supabase for potential real-time features, ensuring collaborative environments where changes are reflected instantly.
- **Accessibility and Usability**: Designed with accessibility in mind, featuring keyboard navigation, screen reader support, and intuitive user flows.

## Technologies Used

### Frontend
- **Next.js 14**: React framework for server-side rendering, routing, and API routes.
- **React 18**: Component-based UI library with hooks for state management.
- **TypeScript**: Strongly typed JavaScript for enhanced code reliability and developer experience.
- **Tailwind CSS**: Utility-first CSS framework for responsive and customizable styling.
- **shadcn/ui**: High-quality, accessible UI components built on Radix UI primitives.

### Backend and Database
- **Supabase**: Backend-as-a-Service providing authentication, real-time database, and API services.
- **Prisma**: Next-generation ORM for type-safe database access and schema management.
- **PostgreSQL**: Robust relational database hosted on Supabase for data persistence.

### Additional Libraries and Tools
- **Lucide React**: Icon library for consistent and scalable icons.
- **Sonner**: Toast notification system for user feedback.
- **React Hook Form**: Efficient form handling with validation.
- **Zustand**: Lightweight state management for client-side data.
- **ESLint**: Code linting for maintaining code quality.
- **Prettier**: Code formatting for consistent style.

## Installation and Setup

### Prerequisites
- Node.js (version 18 or higher)
- npm or yarn package manager
- Git

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/chouaib-saad/TaskFlow-Pro.git
   cd TaskFlow-Pro
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Environment Configuration**:
   - Copy the `.env` file and update the following variables:
     ```
     NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
     NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
     DATABASE_URL=your-postgresql-connection-string
     ```
   - Obtain these values from your Supabase project dashboard.

4. **Database Setup**:
   - Ensure your Supabase project is configured with the required tables (refer to `prisma/schema.prisma`).
   - Push the schema to your database:
     ```bash
     npx prisma db push
     ```

5. **Generate Prisma Client**:
   ```bash
   npx prisma generate
   ```

6. **Start the Development Server**:
   ```bash
   npm run dev
   ```
   - Access the application at `http://localhost:3000`.

## Usage

1. **Registration/Login**: Create an account or log in with existing credentials.
2. **Dashboard Navigation**: Use the sidebar to navigate between projects, tasks, and settings.
3. **Creating Projects**: Add new projects with details and assign team members.
4. **Managing Tasks**: Create tasks within projects, set priorities, and track status.
5. **Collaboration**: Share projects and tasks with team members for efficient workflow management.

## Project Structure

```
TaskFlow-Pro/
├── app/                    # Next.js app directory
│   ├── auth/               # Authentication pages
│   ├── dashboard/          # Main application pages
│   └── layout.tsx          # Root layout
├── components/             # Reusable UI components
│   ├── ui/                 # shadcn/ui components
│   └── theme-provider.tsx  # Theme management
├── lib/                    # Utility libraries
│   ├── supabase.ts         # Supabase client
│   ├── prisma.ts           # Prisma client
│   └── auth.ts             # Authentication configuration
├── prisma/                 # Database schema and migrations
├── supabase/               # Supabase configurations
├── types/                  # TypeScript type definitions
└── README.md               # Project documentation
```

## Security and Best Practices

- **Authentication Security**: Supabase handles secure authentication with JWT tokens and password hashing.
- **Data Validation**: Input validation using React Hook Form and Zod schemas.
- **Environment Variables**: Sensitive data stored securely in environment variables.
- **Code Quality**: ESLint and TypeScript ensure maintainable and error-free code.
- **Responsive Design**: Mobile-first approach with Tailwind CSS for cross-device compatibility.

## Contributing

This project was developed as part of an academic self-learning initiative to explore full-stack web development. Contributions are highly encouraged to enhance functionality, add new features, or improve the codebase. If you are interested in collaborating, please:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

We welcome developers of all skill levels to join and contribute to this project. Feel free to reach out for discussions or mentorship opportunities.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions, suggestions, or collaboration inquiries, please open an issue on GitHub or contact the maintainer.

---

*Note: This application is developed for educational purposes and demonstrates modern web development techniques. It is not intended for production use without further security audits and optimizations.*
# Upload File MVC

A Java web application for file uploading with user authentication, built using Servlet/JSP and following the MVC design pattern.

## Features

- **User Authentication**: Email-based login and registration system
- **Session Management**: Secure session-based authentication with 60-minute timeout
- **Password Security**: SHA-256 encryption with salt
- **File Upload**: Upload files with user tracking
- **User Management**: View all users, edit profile, and delete accounts
- **Protected Routes**: Authentication filter for secure pages

## Technology Stack

- **Backend**: Java Servlet/JSP
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 9.0+
- **Cloud Storage**: Cloudinary (for file uploads)
- **Architecture**: MVC Pattern with Singleton database connection
- **JDBC**: MySQL Connector/J

## Project Structure

```
src/main/java/com/upload_file_mvc/
├── controller/          # Servlet controllers
│   ├── AuthController.java
│   ├── UserController.java
│   └── UploadController.java
├── dao/                 # Data Access Objects
│   └── UserDAO.java
├── model/              # Data models
│   └── User.java
├── util/               # Utility classes
│   ├── DatabaseConnection.java (Singleton)
│   ├── PasswordUtil.java
│   └── SessionUtil.java
└── filter/             # Servlet filters
    └── AuthFilter.java

src/main/webapp/
├── login.jsp
├── register.jsp
├── home.jsp
├── profile.jsp
├── users.jsp
└── WEB-INF/
    └── web.xml
```

## Setup Instructions

### 1. Database Setup
```sql
-- Run the database.sql script to create the schema
mysql -u root -p < database.sql
```

### 2. Configure Database Connection
Edit `DBConfig.java` with your MySQL credentials:
```java
DB_URL = "jdbc:mysql://localhost:3306/upload_file_db"
DB_USERNAME = "your_username"
DB_PASSWORD = "your_password"
```

### 3. Configure Cloudinary
See detailed instructions in [CLOUDINARY_SETUP.md](CLOUDINARY_SETUP.md)

**Quick steps:**
- Sign up at https://cloudinary.com/
- Get your Cloud Name, API Key, and API Secret
- Update `CloudinaryConfig.java` with your credentials
- Add required JARs to `WEB-INF/lib/`:
  - cloudinary-core-2.3.2.jar
  - cloudinary-http44-2.3.2.jar
  - commons-codec-1.15.jar
  - commons-lang3-3.12.0.jar
  - httpclient-4.5.13.jar
  - httpcore-4.4.15.jar

### 4. Add MySQL Connector
- Download MySQL Connector/J JAR
- Place it in `src/main/webapp/WEB-INF/lib/`

### 5. Deploy to Tomcat
- Build the project
- Copy WAR file to Tomcat's `webapps/` directory
- Start Tomcat server

### 6. Access Application
```
http://localhost:8080/UploadFileMVC/login
```

## Key Components

### Authentication System
- **Email-based login**: Users authenticate with email and password
- **Registration**: New user registration with validation
- **Session timeout**: 60 minutes of inactivity
- **Password validation**: Minimum 6 characters with letters and numbers

### Database Schema
- **users**: id, email, password, full_name, created_at
- **uploaded_files**: id, file_name, file_path, file_size, file_type, user_id, cloudinary_public_id, cloudinary_url, upload_date

### Protected Routes
- `/home` - Dashboard
- `/profile` - User profile management
- `/users` - View all users
- `/user/*` - User edit/delete operations
- `/upload` - File upload functionality

## Security Features

- Password encryption with SHA-256 + random salt
- SQL injection prevention using PreparedStatements
- Session-based authentication (no JWT)
- AuthFilter for route protection
- Email uniqueness validation

## License

This project is for educational purposes.

# Personal Productivity Tracker

A comprehensive Spring MVC web application for tracking personal productivity, built with Java, JSP, and modern web technologies.

## Features

- **Dashboard**: Overview of tasks, productivity metrics, and visual charts
- **Task Management**: Create, edit, delete, and organize tasks with priorities and categories
- **Time Tracking**: Track time spent on tasks with start/stop functionality
- **Analytics**: Visual charts showing task distribution by status and priority
- **Responsive Design**: Bootstrap-based responsive UI that works on all devices

## Technologies Used

### Backend
- **Java 11** - Core programming language
- **Spring MVC 5.3** - Web framework for handling HTTP requests and MVC architecture
- **JDBC** - Database connectivity and operations
- **MySQL 8.0** - Relational database for data persistence
- **Maven** - Build tool and dependency management

### Frontend
- **JSP (JavaServer Pages)** - Server-side rendering of dynamic web pages
- **Bootstrap 5.1** - Responsive CSS framework
- **Chart.js** - Interactive charts for data visualization
- **JavaScript/jQuery** - Client-side functionality and AJAX interactions
- **Font Awesome** - Icon library

## Project Structure

```
AJT_Project/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/productivity/tracker/
│   │   │       ├── controller/     # Spring MVC Controllers
│   │   │       ├── dao/           # Data Access Objects
│   │   │       ├── model/         # Entity classes
│   │   │       ├── service/       # Business logic layer
│   │   │       └── config/        # Configuration classes
│   │   ├── webapp/
│   │   │   ├── WEB-INF/
│   │   │   │   ├── views/         # JSP pages
│   │   │   │   ├── web.xml        # Web application configuration
│   │   │   │   └── *.xml          # Spring configuration
│   │   │   └── resources/         # Static resources (CSS, JS)
│   │   └── resources/
│   │       └── database.properties # Database configuration
├── database_schema.sql             # Database schema and sample data
└── pom.xml                        # Maven configuration
```

## Database Schema

The application uses a MySQL database with the following main tables:

- **users** - User account information
- **categories** - Task categorization
- **tasks** - Main task data with priority, status, and timing
- **time_logs** - Time tracking records
- **daily_summary** - Daily productivity summaries
- **goals** - Productivity goals and targets

## Setup Instructions

### Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 9.0+ or any servlet container

### Installation Steps

1. **Clone the project** (or use the existing directory):
   ```bash
   cd /Users/rishijat/Desktop/AJT_Project
   ```

2. **Set up the database**:
   ```bash
   mysql -u root -p
   ```
   Then run the SQL script:
   ```sql
   source database_schema.sql
   ```

3. **Configure database connection**:
   Edit `src/main/resources/database.properties`:
   ```properties
   database.driver=com.mysql.cj.jdbc.Driver
   database.url=jdbc:mysql://localhost:3306/productivity_tracker
   database.username=your_username
   database.password=your_password
   ```

4. **Build the project**:
   ```bash
   mvn clean compile
   ```

5. **Run the application**:
   ```bash
   mvn jetty:run
   ```
   
   The application will be available at: `http://localhost:8080/productivity-tracker`

### Alternative Deployment

To deploy on Tomcat:
```bash
mvn clean package
```
Copy the generated `target/productivity-tracker.war` to your Tomcat webapps directory.

## Features Overview

### Dashboard
- Task statistics with visual charts
- Recent and upcoming tasks overview
- Productivity metrics
- Quick actions for task management

### Task Management
- Create tasks with title, description, priority, and due dates
- Filter tasks by status, priority, or category
- Search functionality
- Mark tasks as complete or update status
- Edit and delete tasks

### Time Tracking
- Start/stop timers for tasks
- Track actual time spent vs estimated time
- View time logs and history
- Calculate productivity metrics

### Analytics
- Visual charts showing task distribution
- Priority-based task analysis
- Productivity trends over time
- Export functionality for data

## API Endpoints

### Task Management
- `GET /` - Dashboard view
- `GET /tasks` - List all tasks
- `GET /tasks/new` - New task form
- `POST /tasks/create` - Create new task
- `GET /tasks/{id}/edit` - Edit task form
- `POST /tasks/{id}/update` - Update task
- `POST /tasks/{id}/delete` - Delete task
- `POST /tasks/{id}/status` - Update task status (AJAX)

### Data API
- `GET /dashboard/stats` - Get dashboard statistics (JSON)
- `GET /tasks/api/list` - Get tasks list (JSON)

## Customization

### Adding New Features

1. **Model Layer**: Add new entity classes in `src/main/java/com/productivity/tracker/model/`
2. **DAO Layer**: Create corresponding DAO interfaces and implementations
3. **Service Layer**: Add business logic in service classes
4. **Controller Layer**: Create new controllers for handling HTTP requests
5. **View Layer**: Add JSP pages for the user interface

### Database Modifications

Update the `database_schema.sql` file with new table structures and run the changes:
```sql
ALTER TABLE tasks ADD COLUMN new_field VARCHAR(255);
```

### UI Customization

- Modify `src/main/webapp/resources/css/styles.css` for custom styles
- Update JSP templates in `src/main/webapp/WEB-INF/views/`
- Add JavaScript functionality in `src/main/webapp/resources/js/app.js`

## Development Notes

### Architecture
- **MVC Pattern**: Separation of concerns with Model, View, and Controller layers
- **DAO Pattern**: Database access abstraction
- **Service Layer**: Business logic separation
- **Dependency Injection**: Spring-managed beans

### Security Considerations
- Input validation on all forms
- SQL injection prevention through prepared statements
- XSS protection in JSP templates
- Session management for user authentication

### Performance
- Connection pooling for database connections
- Efficient SQL queries with proper indexing
- Client-side caching of static resources
- Lazy loading of large datasets

## Troubleshooting

### Common Issues

1. **Database Connection Failed**:
   - Check MySQL server is running
   - Verify database credentials in `database.properties`
   - Ensure database `productivity_tracker` exists

2. **Maven Build Errors**:
   - Check Java version compatibility
   - Clear Maven cache: `mvn clean`
   - Update dependencies: `mvn clean install`

3. **JSP Compilation Errors**:
   - Verify JSTL dependencies in `pom.xml`
   - Check JSP syntax and tag libraries

4. **Static Resources Not Loading**:
   - Verify resource mapping in `dispatcher-servlet.xml`
   - Check file paths in JSP includes

## License

This project is created for educational purposes as part of a college mini-project demonstration.

## Contributing

This is a student project, but feel free to:
- Report bugs or issues
- Suggest new features
- Improve documentation
- Optimize performance

---

**Note**: This is a demo application with a default user (ID: 1). In a production environment, you would implement proper user authentication and authorization.
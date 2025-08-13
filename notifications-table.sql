-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample notifications for testing
INSERT INTO notifications (user_id, type, title, message, data) VALUES
(1, 'assignment', 'New Assignment Available', 'A new assignment "Java Programming Basics" has been assigned to you.', '{"assignmentId": 1, "dueDate": "2024-01-15"}'),
(1, 'grade', 'Assignment Graded', 'Your assignment "HTML Fundamentals" has been graded. Score: 85/100', '{"assignmentId": 2, "score": 85, "maxScore": 100}'),
(1, 'course', 'Course Update', 'New materials have been added to "Web Development Course".', '{"courseId": 1, "materialType": "video"}'),
(2, 'assignment', 'Assignment Due Tomorrow', 'Don\'t forget! Your assignment "CSS Layout" is due tomorrow.', '{"assignmentId": 3, "dueDate": "2024-01-10"}'),
(2, 'system', 'Welcome to Learning Platform', 'Welcome! Your account has been successfully created.', '{"welcomeBonus": true}');

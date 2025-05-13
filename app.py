import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
from werkzeug.utils import secure_filename

from functools import wraps

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('user_id') or not session.get('is_admin'):
            flash("Admin access required", "danger")
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


app = Flask(__name__)
app.secret_key = 'your_secret_key'

# MySQL Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Pubglover@123'
app.config['MYSQL_DB'] = 'news_platform_db'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# File Upload Configuration
UPLOAD_FOLDER = 'static/uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mov', 'avi'}

# Initialize Extensions
mysql = MySQL(app)
bcrypt = Bcrypt(app)

# Check allowed file extensions
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Home Page (News Feed)
@app.route('/')
def home():
    status_filter = request.args.get('status')  # 'verified', 'fake', 'pending', or None

    cur = mysql.connection.cursor()
    query = """
        SELECT news_posts.*, users.username 
        FROM news_posts 
        JOIN users ON news_posts.user_id = users.id
    """

    if status_filter in ['verified', 'fake', 'pending']:
        query += " WHERE news_posts.status = %s ORDER BY news_posts.timestamp DESC"
        cur.execute(query, (status_filter,))
    else:
        query += " ORDER BY news_posts.timestamp DESC"
        cur.execute(query)

    posts = cur.fetchall()
    cur.close()

    return render_template('index.html', posts=posts)

@app.route('/admin')
@admin_required
def admin_dashboard():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT news_posts.*, users.username 
        FROM news_posts 
        JOIN users ON news_posts.user_id = users.id
    """)
    posts = cur.fetchall()
    cur.close()
    return render_template('admin_dashboard.html', posts=posts)

@app.route('/admin/verify/<int:post_id>')
@admin_required
def verify_post(post_id):
    cur = mysql.connection.cursor()
    cur.execute("UPDATE news_posts SET status = 'verified' WHERE id = %s", (post_id,))
    mysql.connection.commit()
    cur.close()
    flash('Post verified.', 'success')
    return redirect(url_for('admin_dashboard'))

@app.route('/admin/fake/<int:post_id>')
@admin_required
def mark_fake_post(post_id):
    cur = mysql.connection.cursor()
    cur.execute("UPDATE news_posts SET status = 'fake' WHERE id = %s", (post_id,))
    mysql.connection.commit()
    cur.close()
    flash('Post marked as fake.', 'warning')
    return redirect(url_for('admin_dashboard'))

@app.route('/admin/delete/<int:post_id>')
@admin_required
def delete_post(post_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM news_posts WHERE id = %s", (post_id,))
    mysql.connection.commit()
    cur.close()
    flash('Post deleted.', 'info')
    return redirect(url_for('admin_dashboard'))


# Register User
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        hashed_pw = bcrypt.generate_password_hash(password).decode('utf-8')

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)",
                    (username, email, hashed_pw))
        mysql.connection.commit()
        cur.close()

        flash('Registration successful!', 'success')
        return redirect(url_for('login'))
    return render_template('register.html')

# Login User
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s", (username,))
        user = cur.fetchone()
        cur.close()

        if user and bcrypt.check_password_hash(user['password_hash'], password):
            session['user_id'] = user['id']
            session['username'] = user['username']
            session['is_admin'] = user.get('is_admin', False)  # ✅ Add this line
            flash('Login successful!', 'success')
            return redirect(url_for('home'))
        else:
            flash('Invalid username or password', 'danger')

    return render_template('login.html')


# Logout User
@app.route('/logout')
def logout():
    session.clear()
    flash('Logged out.', 'info')
    return redirect(url_for('login'))

# Post News
@app.route('/post', methods=['GET', 'POST'])
def post_news():
    if 'user_id' not in session:
        flash('Login required to post news.', 'warning')
        return redirect(url_for('login'))

    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        source_link = request.form.get('source_link')

        image = request.files.get('image')
        image_path = None
        if image and image.filename != '':
            filename = secure_filename(image.filename)
            image_path = f"uploads/{filename}"
            image.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        video = request.files.get('video')
        video_path = None
        if video and video.filename != '':
           filename = secure_filename(video.filename)
           video_path = f"uploads/{filename}"
           video.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))


        # Save News to DB
        cur = mysql.connection.cursor()
        cur.execute("""
    INSERT INTO news_posts (user_id, title, description, source_link, image_path, video_path)
    VALUES (%s, %s, %s, %s, %s, %s)
""", (session['user_id'], title, description, source_link, image_path, video_path))

        mysql.connection.commit()
        cur.close()

        flash('News posted successfully!', 'success')
        return redirect(url_for('home'))

    return render_template('post_news.html')

# Run the App
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)



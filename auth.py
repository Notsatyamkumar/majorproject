from flask import session, redirect, url_for, flash

def login_required(role=None):
    def wrapper(f):
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                flash('Login required', 'warning')
                return redirect(url_for('login'))
            if role and session.get('role') != role:
                flash('Unauthorized access', 'danger')
                return redirect(url_for('home'))
            return f(*args, **kwargs)
        decorated_function.__name__ = f.__name__
        return decorated_function
    return wrapper

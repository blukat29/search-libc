from flask import Blueprint, render_template

search_view = Blueprint('search_view', __name__)

@search_view.route('/')
def index():
    return render_template('index.html')

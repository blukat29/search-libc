from flask import Flask
from .views import search_view

app = Flask(__name__)
app.register_blueprint(search_view)


from flask import Blueprint, jsonify, render_template, request
from collections import OrderedDict

from .engine import engine

search_view = Blueprint('search_view', __name__)

def decode_query(query):
    decoded = {}
    for hint in query.split(','):
        splitted = hint.split(':')
        if len(splitted) == 2:
            key, value = splitted
            decoded[key] = value
    return decoded

@search_view.route('/')
def index():
    query = decode_query(request.args.get('q', ''))
    if len(query) == 0:
        demo_query = OrderedDict([('__libc_start_main_ret','f45'), ('printf','340')])
        return render_template('index.html', query=demo_query)

    libs = engine.find(query)
    return render_template('index.html', query=query, libs=libs)

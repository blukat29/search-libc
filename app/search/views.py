from flask import Blueprint, jsonify, render_template, request

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
    libs = engine.find(query)

    lib = request.args.get('l', '')
    dump = engine.dump(lib, list(query.keys()))

    if len(query) == 0:
        demo_query = {'__libc_start_main_ret':'f45', 'printf':'340'}
        query = demo_query
    return render_template('index.html', query=query, libs=libs, dump=dump)

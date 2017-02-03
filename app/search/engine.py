import subprocess
import os
import re

info_re = re.compile(r'[^(]+\(id (.*)\)')

class Engine(object):

    def __init__(self, libcdb):
        self.libcdb = libcdb

    def _run_database_tool(self, name, args):
        program = os.path.abspath(os.path.join(self.libcdb, name))
        argv = [program] + args
        out = subprocess.check_output(argv, cwd=self.libcdb)
        out = out.decode('utf-8')
        lines = out.splitlines()
        return lines

    def _find_database(self, query):

        args = []
        for key, value in query.items():
            args.append(key)
            args.append(value)

        libs = []
        for line in self._run_database_tool('find', args):
            m = info_re.match(line)
            libs.append(m.group(1))

        return libs

    def find(self, query):
        if len(query) == 0:
            return []
        return self._find_database(query)


engine = Engine('../libc-database')

from subprocess import Popen, PIPE
import os
import re

info_re = re.compile(r'[^(]+\(id (.*)\)')

class Engine(object):

    def __init__(self, libcdb):
        self.libcdb = libcdb

    def _run_database_tool(self, name, args):
        program = os.path.abspath(os.path.join(self.libcdb, name))
        argv = [program] + args

        p = Popen(argv, cwd=self.libcdb, stdout=PIPE, stderr=PIPE)
        out, err = p.communicate()
        if len(err) == 0:
            return out.decode('utf-8')
        else:
            return ''

    def _find_database(self, query):

        args = []
        for key, value in query.items():
            args.append(key)
            args.append(value)

        libs = []
        for line in self._run_database_tool('find', args).splitlines():
            m = info_re.match(line)
            libs.append(m.group(1))

        return libs

    def find(self, query):
        if len(query) == 0:
            return []
        return self._find_database(query)

    def dump(self, lib, names=[]):
        default_names = ['system', 'open', 'read', 'write', 'str_bin_sh']
        argv = [lib] + default_names + names
        raw = self._run_database_tool('dump', argv)
        if len(raw) > 0:
            return {'id': lib, 'raw': raw}
        else:
            return {}

engine = Engine('../libc-database')

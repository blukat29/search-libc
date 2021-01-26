from subprocess import Popen, PIPE
import os
import re
import operator

info_re = re.compile(r'[^(]+\((.*)\)')
ofs_re = re.compile(r'offset_([^\s]+) = 0x([0-9a-fA-F]+)')

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
            return None

    def _find_database(self, query):

        args = []
        for key, value in query.items():
            args.append(key)
            args.append(value)

        found = self._run_database_tool('find', args)
        if not found:
            return []

        libs = []
        for line in found.splitlines():
            m = info_re.match(line)
            if m:
                libs.append(m.group(1))
        return libs

    def find(self, query):
        if len(query) == 0:
            return []
        return self._find_database(query)

    def dump(self, lib, names=[]):
        default_names = ['system', 'open', 'read', 'write', 'str_bin_sh']
        argv = [lib] + default_names + names

        dumped = self._run_database_tool('dump', argv)
        if not dumped:
            return None

        symbols = {}
        for line in dumped.splitlines():
            m = ofs_re.match(line)
            if m:
                symbol = m.group(1)
                ofs = int(m.group(2), 16)
                symbols[symbol] = ofs

        symbols_list = sorted(symbols.items(), key=operator.itemgetter(1))
        return symbols_list


engine = Engine('../libc-database')

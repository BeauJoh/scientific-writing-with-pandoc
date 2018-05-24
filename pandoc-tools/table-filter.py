#!/usr/bin/env python3

# based on https://groups.google.com/d/msg/pandoc-discuss/RUC-tuu_qf0/h-H3RRVt1coJ

import pandocfilters as pf
import sys
import re

def latex(s):
    return pf.RawBlock('tex', s)

def inlatex(s):
    return pf.RawInline('tex', s)

def tbl_caption(s):
    # check if there is no header
    if len(s) == 0:
        return pf.Para([])

    return pf.Para([inlatex(r'\caption{')] + s + [inlatex('}')])

def tbl_alignment(s, default):
    aligns = {
        "AlignDefault": default,
        "AlignLeft": 'l',
        "AlignCenter": 'c',
        "AlignRight": 'r',
    }
    alignment = ['@{}']
    for e in s:
        alignment.append(aligns[e['t']])
    alignment.append('@{}')
    return ''.join(alignment)
    #return ''.join([aligns[e['t']] for e in s])

def tbl_headers(s, delimiter):
    result = [inlatex(r'{')]
    result.extend(s[0][0]['c'][:])
    result.append(inlatex('}'))
    for i in range(1, len(s)):
        result.append(inlatex(r' & {'))
        result.extend(s[i][0]['c'])
        result.append(inlatex('}'))
    result.append(inlatex(delimiter + r'\hline'))
    return pf.Para(result)

def tbl_contents(s, delimiter):
    result = []
    for row in s:
        para = []
        for col in row:
            para.extend(col[0]['c'])
            para.append(inlatex(' & '))
        result.extend(para)
        result[-1] = inlatex(delimiter + '\n')
    return pf.Para(result)

def do_filter(k, v, f, m):
    if k == "Table":
        # is wide?
        wide = -1
        for index, item in enumerate(v[0]):
            if item['t'] == 'Str' and item['c'].startswith('{.wide}'):
                wide = index
                break
        if wide > -1:
            v[0].pop(wide-1) # remove space
            v[0].pop(wide-1) # remove .wide
            v[0].pop(wide-1) # remove space
        # has headers
        headers = (len(v[3][0]) > 0)
        # has caption and is floating?
        caption = (len(v[0]) > 0)
        # print(v[0], file=sys.stderr)
        table = []
        delimiter = ''
        if caption:
            table.append(latex(r'\begin{table*}[tb]' '\n' r'\centering' '\n'))
            if wide > -1:
                table.append(latex(r'\begin{wide}' '\n'))
            table.append(tbl_caption(v[0]))
            table.append(latex(r'\begin{tabularx}{\linewidth}{%s}' % tbl_alignment(v[1], 'X') + ('\n' r'\toprule')))
            delimiter = r'\\'
        # not floating, use longtable
        else:
            table.append(latex(r'\begin{tabular}{%s}' % tbl_alignment(v[1], 'l') + ('\n' r'\hline')))
            delimiter = r'\tabularnewline'
        # check if there is no header
        if headers:
            table.append(tbl_headers(v[3], delimiter))
        table.append(tbl_contents(v[4], delimiter))
        table.append(latex(r'\hline' '\n'))
        if caption:
            table.append(latex(r'\end{tabularx}'))
            if wide > -1:
                table.append(latex(r'\end{wide}' '\n'))
            table.append(latex(r'\end{table*}'))
        else:
          table.append(latex(r'\end{tabular}'))

        return table


if __name__ == "__main__":
    pf.toJSONFilter(do_filter)

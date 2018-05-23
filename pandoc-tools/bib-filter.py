#!/usr/bin/env python
import pandocfilters as pf

def latex(s):
    return pf.RawBlock('tex', s)

def inlatex(s):
    return pf.RawInline('tex', s)

def recite(key, value, format, meta):
    #remove section called bibliography
    if key == 'Header':
        [irrelevent,[section_name, classes, keyvals], code] = value
        #{"t":"Header","c":[1,["references",["unnumbered"],[]],[{"t":"Str","c":"References"}]]}
        if section_name == "references":
            return []
    #add \bibitem to the beginning of each hyper-target
    if key == 'Div':
        [[section_type,x,y],refs] = value
        if section_type == "refs":
            bib_tex = []
            bib_tex.append(latex(r"\begin{thebibliography}{00}"))
            for i in range(0,len(refs)):
                bib_tex.append(latex(r"\bibitem{b"+str(i)+r"}"))
                #dirty hack code to remove the hard-coded hyper-target
                refs[i]['c'][1][0]['c'][0]['c'] = ""
                bib_tex.append(refs[i])
            bib_tex.append(latex(r"\end{thebibliography}"))
            return bib_tex

if __name__ == "__main__":

    pf.toJSONFilter(recite)

#convert:
#remove:
#\section*{References}\label{references}
#\addcontentsline{toc}{section}{References}
#
#\hypertarget{refs}{}
#to:
#\hypertarget{ref-declerck2016cori}{}
#{[}1{]} T. Declerck \emph{et al.}, ``Cori - a system to support data-intensive computing,'' \emph{Proceedings of the Cray User Group}, p. 8, 2016.


#to:
#\begin{thebibliography}{00}
#\hypertarget{refs}{}
#\bibitem{b1}\hypertarget{ref-declerck2016cori}{} T. Declerck \emph{et al.}, ``Cori - a system to support data-intensive computing,'' \emph{Proceedings of the Cray User Group}, p. 8, 2016.
#\end{thebibliography}

#of the form:
#{"t":"Header","c":[1,["references",["unnumbered"],[]],[{"t":"Str","c":"References"}]]}

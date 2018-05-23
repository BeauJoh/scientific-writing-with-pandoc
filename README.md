
A quick demo to getting papers written quickly in markdown
-----------------------------------------------------------

Pandoc is an awesome tool!
This is especially true once properly configured for scientific writing.
Personally, I write all my papers in Markdown — or RMarkdown for the fancy stuff that requires generating figures — and leave pandoc to automatically produces pdfs and LaTeX output.
In fact, all my builds are simultaneously generated for 3 separate versions — corresponding to the major style guides in computer science — ACM, IEEE and LNCS formatting.
I get really distracted writing LaTeX directly -- it's really easy to lose track on what you want to say when writing when you could spend half the day type-setting and resizing figures.
This is where writing in markdown really shines; it allow's you the flexibility of LaTeX -- since TeX can be embedded at any part of the document -- without you going down the long road of type-setting and losing your train of thought.
Best of all, if you're about to submit the paper and need to finally focus on typesetting it's easy to generate a LaTeX output of your work and edit as you normally would using the classic TeX workflow.

Packages used to build the paper include:

* pandoc -- 1.19.2
* pandoc-citeproc -- 0.10.4
* pandoc-crossref -- 0.3.0.0

Feel free to ask me questions via [email](mailto:beau@inbeta.org) about markdown/pandoc and R integration.
The corresponding pdfs can be viewed here as [ACM](https://inbeta.org/wp-content/uploads/2018/05/acm-paper.pdf), [IEEE](https://inbeta.org/wp-content/uploads/2018/05/ieee-paper.pdf) and [LNCS](https://inbeta.org/wp-content/uploads/2018/05/lncs-paper.pdf).

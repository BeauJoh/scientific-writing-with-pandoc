---
title: "Writing sciency things in Markdown -- Pandoc is Awesome!"
abstract: "
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
"
keywords: "pandoc, productivity, awesome"
date: "March 20, 2018"
bibliography: ./bibliography/bibliography.bib
---

<!--IEEE needs the keywords to be set here :(-->
\iftoggle{IEEE-BUILD}{
\begin{IEEEkeywords}
pandoc, productivity, awesome
\end{IEEEkeywords}
}{}

#Introduction

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.

#Related Work


Nychkar et al.[@nychkar] propose a task scheduling framework on a per-node basis for efficiently issuing work between multiple heterogeneous accelerators.
The focus of this work is on dynamic scheduling of tasks while automating data transfers between processing units to better utilise many GPUs HPC systems.
On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.

#Experimental Setup

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#Methodology

The R programming language was used to analyse the data, construct the model and analyse the results.
In particular the `Ranger` package by Wright and Ziegler [@JSSv077i01] was used to for the development of the regression model. 
It is a fast implementation of the Random Forest Breiman [@breiman2001random] or recursive partitioning of high dimensional data.

<!--see ../analysis_tools/exhaustive_grid_search.R for the implementation -->

Here is a markdown list:


* num.trees -- over the range of $10 - 10,000 \text{ by } 500$
* mtry -- ranges from $1 - 34$, where $34$ is the maximum number of input features available from AIWC,
* min.node.size -- ranges from $1 - 50$, where $50$ is the number of observations per sample.


It is important to survey the entire optimisation space by adjusting these parameters since performance of the resultant model can vary significantly with these parameters.

However, too many compute resources are required for an exhaustive grid search of this space.
Instead, the Flexible Global Optimization with Simulated-Annealing, in particular the variant found in the R package \textit{optimization} by Husmann, Lange and Spiegel [@husmannr], was used to examine the consistency of these model tuning parameters.
The simulated-annealing method both reduces the risk of getting trapped in a local minimum and is able to deal with irregular and complex parameter spaces as well as with non-continuous and sophisticated loss functions.
In this setting, it is desirable to minimise the out of bag prediction error of the resultant fitted model, by simultaneously changing the parameters (num.trees, mtry and min.node.size).
The function \textit{optim\_sa} allows us to define the search space of interest, a starting position, a function that changes the magnitude of the steps according the the relative change in points and the function (which is a wrapper of the ranger function accepting the 3 parameters and returning a cost function — the predicted error) for which the minimum is found.
It allows for an approximate global minimum to be detected with significantly fewer iterations than an exhaustive grid search.


<!--if you need to have differences in layout between builds you can use iftoggle:-->
\begin{figure}
\centering
%acm
\iftoggle{ACM-BUILD}{
\includegraphics[width=0.80\columnwidth]{./figure/tux_wizard.png}
}{}
%ieee
\iftoggle{IEEE-BUILD}{
\includegraphics[width=0.80\columnwidth]{./figure/tux_wizard.png}
}{}
\iftoggle{LNCS-BUILD}{
%llncs
\includegraphics[width=0.95\textwidth,height=0.95\textheight,keepaspectratio]{./figure/tux_wizard.png}
}{}
\caption{\label{fig:tux-wiz}Tux, the wizard of open-source.}
\end{figure}


Figure \ref{fig:tux-wiz} is a sweet picture of the penguin tux.

Full coverage was achieved by selecting starting locations in each of the 4 corners along with 8 random internal points — to avoid missing out on some critical internal structure or to emphasise internal details.
Under each run, the \textit{optim\_sa} was allowed to execute until a global minimum was found.
At each step of optimisation a full trace was collected, where all parameters and the corresponding out of bag prediction error value was logged to a file.
This file was finally loaded, the points interpolated — using duplication between points <!-- interp(x=x$mtry,y=x$num.trees,z=x$prediction.error,duplicate=TRUE,extrap=FALSE)--> — and the heatmap generated, using the image.plot function from the fields package [@nychkar].

A lower out of the bag prediction error is better.
Interestingly, we see that there are many similarly small minima and implies that ranger provides a good fit with a high number of “mtry”, variance between optimal model fitting is largely unaffected by selecting the “num.trees”. 

Therefore, it can in turn be proposed that the selection of the final ranger model should be based off a small number of num.trees and a large number of mtry, with the added rationale that the model can be computed faster given a smaller number of trees.
<!--
LaTeX can be used to directly add algorithms
-->

<!--The removelatexerror is for 2 column ACM format, which also mangles spacing -- so the hard-coded baselineskip is used... :( sorry for the hack!-->
\begingroup
\iftoggle{ACM-BUILD}{\vspace{\baselineskip}}{}
\removelatexerror
\begin{algorithm}[H]

    \For{each unique kernel}{
        construct a full data frame with all but the current kernel\;
        run optimization \textit{optim\_sa} with the full data frame at selected starting location\;
        record the final optimal parameters
    }
    \caption{Find the suitability of the optimal parameters for random forest models for future kernels}
    \label{alg:kernel-omission}
\end{algorithm}
\iftoggle{ACM-BUILD}{\vspace{\baselineskip}}{}
\endgroup



--------------------------------------------------------------------------------------------------
         Kernel omitted           num.trees   mtry   min.node.size   prediction error   R-squared 
-------------------------------- ----------- ------ --------------- ------------------ -----------
         invert_mapping              521       31         24              0.043           0.988   

          kmeansPoint                511       30         34              0.0406          0.989   

          lud_diagonal               527       29         35              0.0441          0.989   

          lud_internal               488       31         32              0.0446          0.988   

         lud_perimeter               480       31         36              0.0443          0.989   

              csr                    507       30         41              0.0438          0.989   

        fftRadix16Kernel             484       29         37              0.044           0.988   

        fftRadix8Kernel              529       34         42              0.0431          0.989   

        fftRadix4Kernel              463       30         45              0.0423          0.989   

        fftRadix2Kernel              443       28         31              0.0436          0.988   

 calc_potential_single_step_dev      502       24         13              0.0484          0.987   

     c_CopySrcToComponents           529       31         43              0.041           0.989   

        cl_fdwt53Kernel              499       26         18              0.0472          0.988   

          srad_cuda_1                504       32         23              0.0465          0.988   

          srad_cuda_2                500       29         19              0.0464          0.988   

            kernel1                  536       30         26              0.0451          0.988   

            kernel2                  469       31         21              0.0463          0.988   

           acc_b_dev                 576       28         31              0.0439          0.989   

         calc_alpha_dev              469       30         42              0.0429          0.989   

         calc_beta_dev               498       30         46              0.0428          0.989   

         calc_gamma_dev              517       28         25              0.0444          0.988   

          calc_xi_dev                439       33         48              0.043           0.989   

           est_a_dev                 524       30         49              0.0421          0.989   

           est_b_dev                 533       28         40              0.0431          0.989   

           est_pi_dev                450       31         38              0.0425          0.989   

         init_alpha_dev              558       32         28              0.0257          0.993   

         init_beta_dev               467       30         29              0.0414          0.989   

         init_ones_dev               566       32         48              0.0406          0.989   

      mvm_non_kernel_naive           514       30         48              0.0429          0.989   

     mvm_trans_kernel_naive          449       32         27              0.0439          0.989   

          scale_a_dev                508       31         30              0.0431          0.989   

        scale_alpha_dev              530       30         41              0.0381          0.99    

          scale_b_dev                565       31         43              0.0422          0.989   

       s_dot_kernel_naive            509       30         22              0.045           0.988   

     needle_opencl_shared_1          499       30         35              0.0443          0.989   

     needle_opencl_shared_2          504       29         27              0.045           0.988   

          crc32_slice8               511       29         38              0.0435          0.987   
--------------------------------------------------------------------------------------------------

Table: Optimal tuning parameters from the same starting location for all models omitting each individual kernel.


But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?

\todo{this is how you can write todo notes}

<!--Here is a subsection:-->

##Some Methodology Subsection \label{sec:finding-the-critical-number-of-kernels}

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?

<!--The removelatexerror is for 2 column ACM format, which also mangles spacing -- so the hard-coded baselineskip is used... :( sorry for the hack!-->
\begingroup
\removelatexerror
\newcommand{\isep}{\mathrel{{.}\,{.}}\nobreak}
\iftoggle{ACM-BUILD}{\vspace{\baselineskip}}{}
\begin{algorithm}[H]

    $s \gets 500$\\
    \For{$i \gets 1$ \textbf{to} length($k$)}{
        $v_p \gets []$\\
        $v_m \gets []$\\
        \For{$j \gets 1$ \textbf{to} $s$}{
            $x \gets shuffle(k)$\\
            $y \gets x[1 \isep i]$\\
            \textbf{training data} $\gets subset(\phi,$ kernel $== y)$ \\
            \textbf{test data} $\gets subset(\phi,$ kernel $!= y)$ \\
            discard variables unavailable during real-world training from \textbf{training data} e.g. size, application, kernel name and measured total application time\\
            build ranger model $r$ using \textbf{training data} \\
            generate prediction responses $p$ from $r$ using \textbf{test data}
            append predicted execution times $p$ to $v_p$
            append measured execution times from \textbf{test data} to $v_m$
        }
        compute the mean absolute error $e$ from vector of $p$ relative to vector $m$
        $store(e)$
    }


    \caption{Find the effect of the number of kernels has on the fit of the random forest model.}
    \label{alg:rmse-per-kernel-count}
\end{algorithm}
\iftoggle{ACM-BUILD}{\vspace{\baselineskip}}{}
\endgroup

The procedure to determine how the model performance improves with more kernels is presented in Algorithm~\ref{alg:rmse-per-kernel-count}.

$k$ is the number unique kernels available during model development, $s$ is the desired sample size, $\phi$ is a data frame of the combined AIWC feature-space with measured runtime results.
In this investigation, $k = 37$ and $s = 500$ are used.

The model optimization parameters were taken from Section~\ref{sec:finding-the-critical-number-of-kernels} and since it has been shown that these are suitable for the larger model tuning space is fixed for all model generation.


<!-- see ../analysis_tools/suitable_kernel_counts.R for implementation -->
![\label{fig:pandocy} the more pandocy way to add figures](figure/tux_wizard.png)



The Figure \ref{fig:pandocy} shows a more pandocy way to include figures -- note it also supports including pdfs, eps, jpeg and much more!

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


#Conclusions


In summary we can see that pandoc is the bomb for scientific writing.
The end.


#References


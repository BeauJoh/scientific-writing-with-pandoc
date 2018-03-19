---
title: "Predicting Accelerators with AIWC: An OpenCL based feature-space criteria for device selection"
abstract: "
High Performance Computing (HPC) systems are becoming increasingly heterogenous at the node level, as evidenced by cutting-edge systems with fast interconnects capable of supporting multiple accelerator devices.
OpenCL is an attractive programming model for such accelerators, with wide support from hardware vendors and significant performance portability.
Programs written in OpenCL have diverse computation, communication and memory access characterstics which result in varying performance between accelerators.
AIWC -- the Architecture Independent Workload Characterization tool -- allows these characteristics to be collected/represented.
This work presents a methodology where AIWC features are used to form a model capable of predicting accelerator execution times.
Use of this methodology will result in scheduling of the most appropriate device being selected for any previously unencoutered code and is highly relevant to the supercomputing setting.
An evaluation around the accuracy of predictions over a subset of the Extended OpenDwarfs Benchmark Suite is also presented.
"
keywords: "workload characterization, accelerator, modelling, prediction, HPC"
date: "March 19, 2018"
bibliography: ./bibliography/bibliography.bib
documentclass: acmart
classoption: sigconf
---

<!--
ICPP 2018 : International Conference On Parallel Processing
http://oaciss.uoregon.edu/icpp18/index.php

47th International Conference on Parallel Processing
Eugene, Oregon, USA, 13 August 2018

* Software -- middleware, environments, run-time systems, resource management
* Performance -- modeling, tools
* Algorithms -- scheduling, machine learning, modeling & analysis


ACM 10 page limit
-->


#Introduction



\todo{HPC architectures becoming increasingly heterogeneous}
\todo{OpenCL programs run on wide range of these devices}
\todo{Programs have a wide range of characteristics which affect execution times on each accelerator}
\todo{AIWC was proposed previously in order to collect architecture independent workload characterization features, these features accurately present a feature-space of a variety of program characteristics}
\todo{AIWC operates on OpenCL workloads by simulating an OpenCL device and performing instrumentation to collect these features}
\todo{These features are used to build a model which can predict the execution times of a new OpenCL code over the range of available devices.}
\todo{This in turn can be used to perform scheduling to identify (at least the low hanging fruit around) which accelerator or type of accelerator should be used for }

#Related Work


#Experimental Setup

\todo{AIWC as introduced by Johnston and Milthorpe collects performance critical characteristics of computationally intensive kernels.
These are collected via simulating the execution of an openCL device and occurs on the LLVM IR.
The selected metrics were carefully selected to correspond to no particular architecture, instead the metrics collected correspond to architecture independent workload characterisation.
When compared over a wide range of codes which exemplify the full spectrum of computation, communication and memory access patterns of required by scientific computing this forms a feature-space representation of these codes.
Or rather the expected ranges of each feature under which a direct comparison can be made.}
\todo{AIWC feature list and quick summary}

\todo{The selection and relative contributions of each of these AIWC features are discussed in Section Methodology in the developement of a model that can predict execution times of a workload for a partiular device.}

\todo{The acquisition of response variables used:}
\todo{The Extended OpenDwarfs Suite used (over blah applications and 4 problem sizes)}
\todo{Measuring the execution times over 50 iterations.}


#Methodology

\todo{ranger model}

\todo{optim\_sa function}

#Constructing a model -- Random Forest Regression

The R programming language was used to analyse the data, construct the model and analyse the results.
In particular the `Ranger` package by Wright and Ziegler~\cite{JSSv077i01} was used to for the development of the regression model. 
It is a fast implementation of the Random Forest Breiman~\cite{breiman2001random} or recursive partitioning of high dimensional data.

#Pruning Forests -- Refining Models





<!--see ../analysis_tools/exhaustive_grid_search.R for the implementation -->

The Random Forest method accepts three parameters in order to adjust the fit of the resultant model.
These parameters and the corresponding search space include:


* num.trees -- over the range of $10 - 10,000 \text{ by } 500$
* mtry -- ranges from $1 - 34$, where $34$ is the maximum number of input features available from AIWC,
* min.node.size -- ranges from $1 - 50$, where $50$ is the number of observations per sample.


It is important to survey the entire optimisation space by adjusting these parameters since performance of the resultant model can vary significantly with these parameters.

However, too many compute resources are required for an exhaustive grid search of this space.
Instead, the Flexible Global Optimization with Simulated-Annealing, in particular the variant found in the R package \textit{optimization} by Husmann, Lange and Spiegel~\cite{husmannr}, was used to examine the consistency of these model tuning parameters.
The simulated-annealing method both reduces the risk of getting trapped in a local minimum and is able to deal with irregular and complex parameter spaces as well as with non-continuous and sophisticated loss functions.
In this setting, it is desirable to minimise the out of bag prediction error of the resultant fitted model, by simultaneously changing the parameters (num.trees, mtry and min.node.size).
The function \textit{optim\_sa} allows us to define the search space of interest, a starting position, a function that changes the magnitude of the steps according the the relative change in points and the function (which is a wrapper of the ranger function accepting the 3 parameters and returning a cost function — the predicted error) for which the minimum is found.
It allows for an approximate global minimum to be detected with significantly fewer iterations than an exhaustive grid search.





\begin{figure}
\centering
\iftoggle{ACM-BUILD}{
%acm
\includegraphics[width=0.80\columnwidth]{./figure/full-scan-random-sampled-heatmap-1.pdf}
}{
%llncs
\includegraphics[width=0.95\textwidth,height=0.95\textheight,keepaspectratio]{./figure/full-scan-random-sampled-heatmap-1.pdf}
}
\label{fig:full-scan-random-sampled-heatmap}
\caption{Full coverage of num.trees and mtry tuning parameters with min.node.size fixed at 9.}
\end{figure}


Figure~\ref{fig:full-scan-random-sampled-heatmap} was generated to visually survey the changes between two such parameters -- mtry and num.trees -- and how the selection of these impacts the overall suitability of the random-forest ranger model.
It is performed over a subset of search-space (where min.node.size was set to 9) since visualising 3d volumetric trends is both difficult, and largely unnecessary -- the selection of the value to fix min.node.size was determined using the same methodology as the following.

Full coverage was achieved by selecting starting locations in each of the 4 corners along with 8 random internal points — to avoid missing out on some critical internal structure or to emphasise internal details.
Under each run, the \textit{optim\_sa} was allowed to execute until a global minimum was found.
At each step of optimisation a full trace was collected, where all parameters and the corresponding out of bag prediction error value was logged to a file.
This file was finally loaded, the points interpolated — using duplication between points <!-- interp(x=x$mtry,y=x$num.trees,z=x$prediction.error,duplicate=TRUE,extrap=FALSE)--> — and the heatmap generated, using the image.plot function from the fields package~\cite{nychkar}.

A lower out of the bag prediction error is better.
Interestingly, we see that there are many similarly small minima and implies that ranger provides a good fit with a high number of “mtry”, variance between optimal model fitting is largely unaffected by selecting the “num.trees”. 

Therefore, it can in turn be proposed that the selection of the final ranger model should be based off a small number of num.trees and a large number of mtry, with the added rationale that the model can be computed faster given a smaller number of trees.

Identifying the global optimum -- minimising the out of the bag predicted error -- follows the same optimisation procedure, except allowing the \textit{optim\_sa} optimization function to traverse all 3 parameters simultaneously.

The optimal parameters for the full model were determined to be num.trees = 505, mtry = 30 and min.node.size = 34, how these were determined is presented in the following Section.


#Model Usefulness Testing by Kernel Omission \label{sec:kernel-omission}

The selected (and final) model should be general purpose such that a new (and untrained) kernel can have the execution times correctly predicted over the full range of accelerators.
To show this, the model must not be over fitted -- that is to say, the random forest model parameters should be general purpose enough to have the same parameters and still yield a good regression prediction.
An examination is presented in Section~\ref{sec:skip-one-finding-an-optima}.
Additionally, a real world use case requires a representative sample of kernels to be used in the training phase such that the full coverage of the AWIC feature space can incorporate any new kernels, since it is expected that new kernels can be incorporated into the existing model without requiring retraining.
This analysis is presented in Section~\ref{sec:finding-the-critical-number-of-kernels}.

##Skip-a-kernel -- The Relative Change in Optima \label{sec:skip-one-finding-an-optima}

\todo{word smith the following 2 sentences}
An additional study was conducted to verify the usefulness of this model for the scheduling setting, and occured by evaluating how the fitted model tuning parameters required altering according to each individual kernel be excluded.

We could simply run the \textit{optima\_sa} from a starting location (of say num.trees=500 and mtry=32 and min.node.size=9) and compare where this optima finishes according to omitted kernel — if they change very little we could assume the model is largely unaffected by removing any individual kernel, and thus our model is well suited to the real world scheduling problem/setting. 

An analysis to determine the general robustness of optimisation parameters for the random forest model over various models, is presented -- where each new model is comprised of all kernels excluding one.
The procedure used to examine this robustness is presented in Algorithm~\ref{alg:kernel-omission}.
The selected starting location was chosen to be num.trees$=500$ and mtry$=32$ and min.node.size $=9$ and where \textit{optim\_sa} runs the optimization wrapper function which finds the optima/minima of the prediction.error of the ranger random forest model.
The final optima parameters for each omitted kernel are presented in Table~\ref{tab:optimal-tuning-parameters}.

<!--The remove latexerror is for 2 column ACM format-->
\begingroup
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



All column values show a similar set of parameters when performing optimization when minimising the out of bag prediction error.
Regardless of which kernel is omitted the R-squared values -- or explained variance -- is very high, indicating a good model fit.
Since the parameters found from the optimization are largely unchanged with each omitted kernel, the median for each of these parameters was selected for the final model.
The optimal parameters for a general purpose model were determined to be num.trees = 505, mtry = 30 and min.node.size = 34.

\todo{write a lead in and write out to the next section}

##Finding the Suitable Number of Kernels \label{sec:finding-the-critical-number-of-kernels}

The usefulness of the developed model was evaluated under a realistic setting, namely, predicting execution times of a new (untrained) kernel.
Namely, this analysis aims at identifying the number of kernels required for the trained model to be general purpose enough for future kernels.

If the selection of kernels used in training adequately saturate the AIWC feature space then the model is general purpose enough to avoid the need for retraining when future kernels are given and thus is suitable for the super computer node level scheduling setting -- where scheduling kernels to devices should require minimal computation.

Measured experimental runtimes were used to evaluate the accuracy of these predictions.
The final metric computed to evaluate each of the models is the MAE -- or mean absolute error -- which gives an equal weight to all errors associated with a poor prediction.

All permutations of 37 kernels were tested by omitting each individual kernel from the training dataset and performing the prediction of the untrained kernels predictor variables -- taken from the AIWC feature space.

<!--The remove latexerror is for 2 column ACM format-->
\begingroup
\removelatexerror
\newcommand{\isep}{\mathrel{{.}\,{.}}\nobreak}
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
\endgroup

The procedure to determine how the model performance improves with more kernels is presented in Algorithm~\ref{alg:rmse-per-kernel-count}.

$k$ is the number unique kernels available during model development, $s$ is the desired sample size, $\phi$ is a data frame of the combined AIWC feature-space with measured runtime results.
In this investigation, $k = 37$ and $s = 500$ are used.

The model optimization parameters were taken from Section~\ref{sec:skip-one-finding-an-optima} and since it has been shown that these are suitable for the larger model tuning space is fixed for all model generation.


<!-- see ../analysis_tools/suitable_kernel_counts.R for implementation -->
![\label{fig:rmse-vs-kernel-count} MAE compared to a model comprised of a number of kernels](figure/rmse_vs_kernel_count-1.pdf)



The results are presented in Figure~\ref{fig:rmse-vs-kernel-count}.

We see the model improves in fit as the number of kernels used increases.
In particular, larger improvements occur as with each new kernel early in the series and tapers off as a new kernel is added to an already large number of kernels.
While the gradient is still significant until the largest number of samples examined ($k=37$) it is envisaged that it model improvement will plateau at some point in the near future.
It is unknown precisely how many kernels are needed -- when this point of diminishing returns is encountered -- to form a general purpose model.
However, the model proposed is a proof of concept and shows that a general purpose model is attainable and need not require many more kernels.

#Evaluation


Figure~\ref{fig:selected-model-actual-vs-predicted-times} presents the actual kernel execution times against the predicted execution times given the optimal model.

![\label{fig:selected-model-actual-vs-predicted-times} The predicted verses measured execution times of all kernels ](figure/actual-vs-predicted-size-plot-1.pdf)

Figure~\ref{fig:selected-model-actual-vs-predicted-times} shows the predicted versus the measured datum and are sorted according to problem size.
Each kernel timing is presented as a dot.
Generally, most of these points are linearly correlated and indicate a good model fit such that the predicted times closely match the experimentally measured execution times of each kernel.
Under predictions typically occur on 4 kernels over the medium and large problem sizes, while over predictions occur on the tiny and small problem sizes.
However these outliers are visually over represented in this figure as the final mean absolute error low, at ~0.16.



#Making Predictions


This section is added to highlight the difference in predicted vs measure performance on a per kernel basis and highlights the suitability and a working usage of the model in the scheduling setting.


![\label{fig:predictive-heatmap-accuracy} The absolute difference between medians of predicted vs measured execution times for each kernel over 4 problem sizes.](figure/predictive-heatmap-accuracy-1.pdf)

```
## TableGrob (2 x 2) "arrange": 4 grobs
##   z     cells    name           grob
## 1 1 (1-1,1-1) arrange gtable[layout]
## 2 2 (1-1,2-2) arrange gtable[layout]
## 3 3 (2-2,1-1) arrange gtable[layout]
## 4 4 (2-2,2-2) arrange gtable[layout]
```


4 heatmaps are presented per each problem size in Figure~\ref{fig:predictive-heatmap-accuracy}, tiny is presented in the top-left, small in the top-right, medium bottom-left, large bottom-right.
In these heatmaps the absolute difference in medians between predicted and measured kernel execution times is shown.


![\label{fig:predictive-heatmap-percentage} The percentage of error between the means of predicted vs measured execution times for each kernel invocation over 4 problem sizes.](figure/predictive-heatmap-percentage-1.pdf)

![\label{fig:predictive-heatmap-percentage} The percentage of error between the means of predicted vs measured execution times for each kernel invocation over 4 problem sizes.](figure/predictive-heatmap-percentage-2.pdf)

![\label{fig:predictive-heatmap-percentage} The percentage of error between the means of predicted vs measured execution times for each kernel invocation over 4 problem sizes.](figure/predictive-heatmap-percentage-3.pdf)

![\label{fig:predictive-heatmap-percentage} The percentage of error between the means of predicted vs measured execution times for each kernel invocation over 4 problem sizes.](figure/predictive-heatmap-percentage-4.pdf)



The 4 heatmaps presented in Figure~\ref{fig:predictive-heatmap-percentage} shows the absolute difference in means between predicted and measured kernel execution times but presented as a percentage of the median actual exection time, thus it depicts the relative percent errors in prediction.
Similarly, tiny is presented in the top-left, small in the top-right, medium bottom-left, large bottom-right. 

#The benefits of this approach

![\label{fig:small-gem-box-and-whisker} The combined kernel execution times to perform a small GEM computation on 8 accelerators.](figure/small-gem-box-and-whisker-1.pdf)

A motivating example for the usage of the proposed model in the real world super computing setting is shown in Figure~\ref{fig:small-gem-box-and-whisker}.
For this particular instance of a small GEM computation an individual kernel -- denoted \textit{calc\_potential\_single\_step\_dev} -- is invoked once and requires 1.47 to 22.61 milliseconds to depending on accelerator to complete.



However, the prediction has a mean error of 0.72 milliseconds, which is typically an order of magnitude better than experimental variance.

As such, the proposed model provides accurate execution time predictions on a per kernel run basis, and is highly useful for estimating time on an accelerator which in turn is critical for scheduling of these resources on supercomputers.

#Conclusions and Future Work

At the beginning of this research, having a model that could indicate 
\todo{is there any future work? Build a scheduler with it to show pipeline improvements?}

The proposed model also works with power-aware and energy-efficient selection of accelerator devices, where the response variable can be directly swapped for an energy consumption metric -- such as joules -- instead of execution time.
However, the RAPL and NVML energy measurement tools require super-user privileges, which we have on only 2 of the 8 accelerator devices, as such these results are not shown.


#References


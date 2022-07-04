---
title: "First Post"
date: 2022-06-30T17:12:06+08:00
---

#### 背景——挑战一[2]

解决**强化学习**的本质是最大化个体在与环境交互过程中获得的累计奖励，



而像**马里奥**这样的游戏在探索的过程中几乎**没有外部奖励**，只有最后到终点才能获得奖励。这也是这也是这个任务的第一个挑战。

#### 背景——挑战二[3]

第二个挑战在于两点：

1. 模型很难直接在图像上建立

因为通常来说：

> 在外部奖励稀薄时，大多数内在奖励的表述可以分为两大类：
>
> 1. 鼓励代理人探索“新的”状态
> 2. 鼓励代理人执行行动，以减少代理人预测其自身行动后果的能力(即其对环境的了解)中的错误/不确定性


上面这两类就分别需要测量新颖性的环境状态分布的统计模型和测量不确定性的环境动力学模型。

但这两种模型都很难在图像等高维连续状态空间中建立。

并且，*读第二点*

环境中还存在噪声，*第三点*

这说明，直接将图像作为状态输入给代理不行，



#### 挑战二的解决策略[4]

要解决这个问题，「只有当代理遇到难以预测但“可学习”的状态时才给予奖励」采取的方法是

*读ppt*

> 为了确定一个好的特征空间来进行未来预测，让我们将所有可以影响代理观察的源分为三种情况：(1)代理可以控制的事情；(2)代理不能控制但可以影响代理的事情(例如，另一个代理驾驶的车辆)；以及(3)代理不能控制的、不影响代理的事情(例如，移动树叶)。一个好的好奇心特征空间应该是模型(1)和(2)，并且不受(3)的影响。后者是因为，如果有一个对代理人来说无关紧要的变异来源，那么代理人就没有动力知道它。

#### 好奇心机制[5,6]

这样挑战二就解决了，而对于挑战1，外部奖励少的问题，作者采用好奇心机制驱动内部奖励的方法帮助代理达到目的。



> 我们的代理由两个子系统组成：一个是输出好奇心驱动的内在奖励信号的奖励生成器，另一个是输出一系列动作以最大化该奖励信号的策略。除了内在的奖励，代理人还可以选择从环境中获得一些外在的奖励。设代理人在t时刻产生的内在好奇心奖励为Rt，外在好奇心奖励为Rt。策略子系统被训练成最大化这两个奖励RT=Rt+Ret之和，其中Rt几乎(如果不总是)为零。

#### 结果[7]









---

使用asc进行策略学习

除非另有说明，否则我们使用符号π(S)来表示参数化策略π(s；θP)。我们的好奇心奖励模型可以潜在地用于一系列策略学习方法；在这里讨论的实验中，我们使用异步优势参与者批评者策略梯度(A3C)(Mnih等人，2016)进行策略学习。我们的

---





##### 挑战1：

这是这篇文章的背景，该任务主要是面临两个挑战

第一个挑战是：



> 

##### 挑战2：

环境中存在的噪声

> 另一个挑战在于处理代理-环境系统的随机性，这既是由于代理的激励中的噪声，更根本的是由于环境中固有的随机性。以(Schmidhuber，2010)为例，如果接收图像作为状态输入的代理正在观察显示白噪声的电视屏幕，则每个状态都将是新的，因为它不可能预测未来任何像素的值。这意味着代理将对电视屏幕保持好奇心，因为它不知道状态空间的某些部分根本无法建模，因此代理可能落入人工好奇心陷阱并停止其探索。这种随机性的其他例子包括由于来自其他移动实体的阴影或干扰对象的存在而引起的外观变化。有些不同，但相关的是在物理上(可能还有视觉上)不同但功能相似的环境部分进行泛化的挑战，这对大规模问题至关重要。解决所有这些问题的一个建议的解决方案是，只有当代理遇到难以预测但“可学习”的状态时才给予奖励(Schmidhuber，1991)。然而，估计可学习性是一个不平凡的问题(Lope等人，2012年)。



##### 两个挑战的解决方法：

不是在原始像素上进行预测，而是使用将其转化到一个特征空间（通过一个神经网络、自监督学习，输入当前状态和下一个状态预测动作以训练），在特征空间中执行与代理执行的动作相关的信息，

> 然而，我们通过以下关键洞察力设法避免了以前预测方法的大多数陷阱：我们只预测环境中可能由于我们代理的操作或影响代理而发生的变化，而忽略其余的。也就是说，我们不是在原始的感觉空间(例如像素)中进行预测，而是将感觉输入转换到一个特征空间，在特征空间中只表示与代理执行的动作相关的信息。我们通过自我监督来学习这个特征空间--在代理逆动力学任务中训练神经网络，预测给定代理当前和下一个状态的代理操作。由于神经网络只需要预测动作，因此它没有动力在其特征嵌入空间内表示环境中不影响代理本身的变化因素。

测量新颖性需要环境状态分布的统计模型，而测量预测误差/不确定性需要建立环境动力学模型，该模型预测给定当前状态(St)和在时间t执行的动作(At)的下一状态(st+1)。这两个模型都很难在高维连续状态空间(如图像)中建立。另一个挑战在于处理代理-环境系统的随机性，这既是由于代理的激励中的噪声，更根本的是由于环境中固有的随机性。以(Schmidhuber，2010)为例，如果接收图像作为状态输入的代理正在观察显示白噪声的电视屏幕，则每个状态都将是新的，因为它不可能预测未来任何像素的值。这意味着代理将对电视屏幕保持好奇心，因为它不知道状态空间的某些部分根本无法建模，因此代理可能落入人工好奇心陷阱并停止其探索。这种随机性的其他例子包括由于来自其他移动实体的阴影或干扰对象的存在而引起的外观变化。有些不同，但相关的是在物理上(可能还有视觉上)不同但功能相似的环境部分进行泛化的挑战，这对大规模问题至关重要。解决所有这些问题的一个建议的解决方案是，只有当代理遇到难以预测但“可学习”的状态时才给予奖励(Schmidhuber，1991)。然而，估计可学习性是一个不平凡的问题(Lope等人，2012年)。

**好奇心机制**

好奇心机制是一个策略函数，用于鼓励探索和发现新状态，对于获取未来回报很有效。这对于这种外部奖励

> 然后，我们使用这个特征空间来训练一个前向动力学模型，该模型预测下一个状态的特征表示，给定当前状态和动作的特征表示。我们将前向动力学模型的预测误差作为内在奖励提供给代理，以鼓励其好奇心。

环境状态分布的统计模型（测量新颖性）与环境动力学模型（测量预测误差）

好奇心作用：

- 解决奖励稀少任务
- 帮助代理在探索新知识的过程中探索其环境
- 好奇心是一种让代理学习在未来场景中可能有帮助的技能的机制

> 在解决奖励稀少的任务时，好奇心的作用已被广泛研究。在我们看来，好奇心还有另外两个基本用途。好奇心帮助代理在探索新知识的过程中探索其环境(探索行为的一个理想特征是，随着代理获得更多的知识，它应该得到改善)。此外，好奇心是一种让代理学习在未来场景中可能有帮助的技能的机制。在这篇文章中，我们评估了我们的好奇心公式在这三个角色中的有效性。



在外部奖励稀疏的环境中，有了好奇心驱动的内部奖励可以帮助代理很好的完成这个任务

泛化性





实验+结果+结论

对于这种需要连续精准操作的游戏，随机探索的效果往往很差。

---

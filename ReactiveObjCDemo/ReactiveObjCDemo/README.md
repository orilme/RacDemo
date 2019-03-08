#  Class
学习框架首先搞清楚框架中常用的类，在RAC中最核心的类RACSiganl。
1. RACSiganl:信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。

RACEmptySignal ：空信号，用来实现 RACSignal 的 +empty 方法；
RACReturnSignal ：一元信号，用来实现 RACSignal 的 +return: 方法；
RACDynamicSignal ：动态信号，使用一个 block - 来实现订阅行为，我们在使用 RACSignal 的 +createSignal: 方法时创建的就是该类的实例；
RACErrorSignal ：错误信号，用来实现 RACSignal 的 +error: 方法；
RACChannelTerminal ：通道终端，代表 RACChannel 的一个终端，用来实现双向绑定。

注意：
* 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
* 默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
* 如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。


2. RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议 

3. RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。

4. RACSubject:（RACSubject、RACReplaySubject）
* RACSubject:信号提供者，自己可以充当信号，又能发送信号。 
  使用场景:通常用来代替代理，有了它，就不必要定义代理了。
* RACReplaySubject:重复提供信号类，RACSubject的子类。
* RACReplaySubject与RACSubject区别:
  RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
* 使用场景：
  使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
  使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值
  
5. RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
  
6. RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
  使用场景:监听按钮点击，网络请求
  
7. RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
  使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
  
8. RACTuple:元组类,类似NSArray,用来包装值.
9. RACScheduler:RAC中的队列，用GCD封装的。
10. RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
11. RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。

# Macro ：（ReactiveCocoa常见宏）
1. RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
2. RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
3. RACTuplePack：把数据包装成RACTuple（元组类）
4. RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。

#  Method
ReactiveCocoa核心方法bind

1. RACBindMethodVC
bind方法，在RAC中有着举足轻重的作用，没有它，很多功能都是没有办法实现。flattenMap、skip、take、takeUntilBlock、skipUntilBlock、distinctUntilChanged等function都用到了bind方法。我们可以发现很多地方都继承和重写bind方法

2.  RACMapMethodVC（ReactiveCocoa操作方法之映射）
FlatternMap和Map的区别
1.FlatternMap中的Block返回信号。
2.Map中的Block返回对象。
3.开发中，如果信号发出的值不是信号，映射一般使用Map
4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。

3. RACCombineMethodVC（ ReactiveCocoa操作方法之组合）
concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件
combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号
reduce(聚合):用于信号发出的内容是元组，把信号发出元组的值聚合成一个值

4. RACFilterMethodVC（ReactiveCocoa操作方法之过滤）
filter：过滤，每次信号发出，会先执行过滤条件判断
ignore：内部调用filter过滤，忽略掉ignore的值
distinctUntilChanged：当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
take：从开始一共取N次的信号
takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号
takeUntil:(RACSignal *):获取信号直到某个信号执行完成
skip:(NSUInteger):跳过几个信号,不接受
switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号

5. RACOrderMethodVC
doNext: 执行Next之前，会先执行这个Block
doCompleted: 执行sendCompleted之前，会先执行这个Block

6. RACTimeMethodVC（ ReactiveCocoa操作方法之时间）
timeout：超时，可以让一个信号在一定的时间后，自动报错
interval 定时：每隔一段时间发出信号
delay 延迟发送next

7. RACRepeatMethodVC（ReactiveCocoa操作方法之重复）
retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功
replay(重放)：当一个信号被多次订阅,反复播放内容
throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出

8. ReactiveCocoa操作方法之线程
deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用
subscribeOn: 内容传递和副作用都会切换到制定线程中

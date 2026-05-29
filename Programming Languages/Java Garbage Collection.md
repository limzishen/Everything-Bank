# The heap structure 
```
JVM Heap
├── Young Generation
│   ├── Eden Space        ← new objects allocated here
│   ├── Survivor S0       ← objects that survived 1 GC
│   └── Survivor S1       ← objects that survived 2 GC
└── Old Generation        ← long lived objects promoted here
```

Have a GC roots (Basically a tree), sweep through the heap and remove anything without reference to it 

Objects are move through the tier for each sweep when it is not removed 
Reduce the size of the heaps needed to be scanned through 

## Stop the world 
Everything is stopped until GC is completed 


# GC selection. 
#### Serial GC

```
-XX:+UseSerialGC

Single threaded, stop the world
Only for small single-core applications
Never use in production payment systems
```

#### Parallel GC

```
-XX:+UseParallelGC

Multiple threads for GC
Still stop the world but faster
Good for batch processing where throughput matters more than latency
```

#### G1GC (Garbage First) — Most Common Production Choice

```
-XX:+UseG1GC  (default in Java 9+)

Divides heap into equal sized regions
Collects regions with most garbage first (hence "Garbage First")
Aims to meet a pause time target
Good balance of throughput and latency
```

```
Heap divided into regions:
[E][E][S][O][E][O][H][E][S][O]
 E=Eden  S=Survivor  O=Old  H=Humongous(large objects)
 
G1 tracks garbage density per region
Collects highest garbage regions first
→ predictable pause times
```

#### ZGC — Low Latency Champion

```
-XX:+UseZGC  (Java 15+ production ready)

Pause times under 1ms regardless of heap size
Does most work concurrently with application threads
Slightly lower throughput than G1
Best for latency sensitive systems — like payment processing
```

#### Shenandoah

```
-XX:+UseShenandoahGC

Similar to ZGC — concurrent, low pause
Developed by Red Hat
Good alternative to ZGC
```

#### Decision Framework

```
Batch jobs, throughput priority    → Parallel GC
Most production services           → G1GC
Payment/financial, latency critical → ZGC or Shenandoah
Old Java versions (pre 11)         → G1GC
```


# Typical tuning
Just adjust the heap sizing when needed 


clear

clang++-3.5 -Wc++11-extensions -O0 -g0 -c -emit-llvm $1 -o build/$2_original.bc
echo "clang++ .cpp to .bc of ORIGINAL complete"

llvm-dis build/$2_original.bc -o build/$2_original.ll
clang++-3.5 -Wc++11-extensions -pthreads build/$2_original.ll -o build/$2_original
echo "llvm-dis, and clang++ compilation of ORIGINAL complete"

#opt -mem2reg -S build/cur.ll -o build/cur.ll
#opt -simplifycfg -S build/cur.ll -o build/cur.ll
#echo "llvm optimizations complete"

~/Eve/build/Debug+Asserts/bin/instrGraph build/$2_original.ll > build/$2.gv
echo "Eve modification complete"

mv output.bc build/$2_modified.bc
llvm-dis build/$2_modified.bc -o build/$2_modified.ll
#clang++-3.5  -pthreads build/$2_modified.ll -o build/$2_modified
clang++-3.5 -pthreads build/$2_modified.ll ../build/Debug+Asserts/lib/libaugment-rt.a -o build/$2_modified
echo "llvm-dis, and clang++ compilation of MODIFIED complete"

sed 's/0x/x/g' build/$2.gv > build/temp.gv
mv build/temp.gv build/$2.gv
dot -Tpdf build/$2.gv -o $2.pdf
echo "GraphViz PDF created"
#scp $2 24.87.92.19:/home/tdwyer/Eve/test/$2.pdf
head -n 50 build/$2.gv


#scp build/$2 sumi.cs.sfu.ca:~/$2

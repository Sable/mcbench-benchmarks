function my_compile(varargin)
!"%VS90COMNTOOLS%vsvars32.bat" & nvcc -c -arch compute_13 test.cu
n=getenv('CUDA_LIB_PATH'); if n(1)=='"', n=n(2:end); end, if n(end)=='"', n=n(1:end-1);end
mex(['-L' n],'-lcudart','test.obj',varargin{:});
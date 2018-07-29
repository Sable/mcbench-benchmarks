function FPDF = PDFFn (PDFType, Arg1, Arg2)
% Return pointers to functions to calculate functions of the PDF
%
% For the generalized gamma distribution, an additional parameter has to
% be supplied. For the tabulated distribution, samples of the pdf have
% to be supplied as a vector of x values and the corresponding pdf values.

switch (lower(PDFType))
  case ('gauss')
    FPDF = GaussPDF;
  case ('uniform')
    FPDF = UniformPDF;
  case ('laplace')
    FPDF = LaplacePDF;
  case ('sine')
    FPDF = SinePDF;
  case ('gamma')
    FPDF = GammaPDF;
  case ('general_gamma')
    FPDF = GammaGenPDF(Arg1);
  case ('tabulated')
    FPDF = TabulatedPDF(Arg1, Arg2);
  otherwise
    error('Unsupported PDF type');
end

return

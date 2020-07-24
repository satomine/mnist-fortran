# Fortran MNIST Parser
This module provides parsers which load an [MNIST] dataset file and generate a Fortran array.

## Requirements
- GNU Fortran 9.3.0

## Import
To use this module, put a `use` statement like `use mnist` in your program unit.  
You can compile the module and your program at the same time:
```console
gfortran mnist.f90 your_program.f90
```
or compile only this module into an object file in advance, and link your program with it:
```console
gfortran -c mnist.f90
gfortran mnist.o your_program.f90
```

## Interface
### Constants
- `TRAINING_IMAGE_COUNT`  
  Number of items in the training dataset.
- `TEST_IMAGE_COUNT`  
  Number of items in the test dataset.
- `ROW_COUNT`  
  Number of rows in an image.
- `COLUMN_COUNT`  
  Number of columns in an image.
- `PIXELS_PER_IMAGE`  
  Number of pixels in an image, equals to `ROW_COUNT * COLUMN_COUNT`.
- `IMAGE_DIMENSION`  
  Equal to `[COLUMN_COUNT, ROW_COUNT]`.

### Functions
- `parse_training_images(file_name)`  
  Load the training set images.  
  Return a 2D `integer` array of shape `(PIXELS_PER_IMAGE, TRAINING_IMAGE_COUNT)`.  
  Its first dimension has the pixel values (from 0 to 255) in row-major order.  
  The second dimension represents the sequence of the images in the dataset.
- `parse_test_images(file_name)`  
  Load the test set images.  
  Same as `parse_training_images`, but of shape `(PIXELS_PER_IMAGE, TEST_IMAGE_COUNT)`.
- `parse_training_labels(file_name)`  
  Load the training set labels.  
  Return a 1D `integer` array of size `TRAINING_IMAGE_COUNT`.  
  It has the label values of the dataset.
- `parse_test_labels(file_name)`  
  Load the test set labels.  
  Same as `parse_training_labels` but of size `TEST_IMAGE_COUNT`.

`file_name` is of type `character` (any length).  
It shall be an absolute or relative path of a dataset file to load.

## Example code
[`example.f90`](example.f90) shows a usage example of this module.  
It requires that the [MNIST] dataset files should exist in the working directory.

## License
[MIT License](LICENSE)

[MNIST]:http://yann.lecun.com/exdb/mnist/

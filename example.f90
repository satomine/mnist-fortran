! MNIST-Fortran usage example
!
! Load the MNIST dataset files and store the images and the labels as Fortran arrays
! Machine learning stuff is not included
!
! This program requires that the MNIST dataset files
! (`train-images-idx3-ubyte`, `train-labels-idx1-ubyte`,
! `t10k-images-idx3-ubyte` and `t10k-labels-idx1-ubyte`) should exist in the working directory.
! You can download them from the MNIST database of handwritten digits (`http://yann.lecun.com/exdb/mnist/`).

program main
    use mnist
    implicit none
    
    integer :: training_images_int(PIXELS_PER_IMAGE, TRAINING_IMAGE_COUNT)
    integer ::     test_images_int(PIXELS_PER_IMAGE,     TEST_IMAGE_COUNT)
    
    real    :: training_images(PIXELS_PER_IMAGE, TRAINING_IMAGE_COUNT)
    integer :: training_labels(TRAINING_IMAGE_COUNT)
    
    real    :: test_images(PIXELS_PER_IMAGE, TEST_IMAGE_COUNT)
    integer :: test_labels(TEST_IMAGE_COUNT)
    
    ! Pixels in an MNIST image are in row-major order
    real :: image_2d(COLUMN_COUNT, ROW_COUNT)
    
    integer :: i
    
    ! Parse datasets
    training_images_int = parse_training_images("./train-images-idx3-ubyte")
    training_labels     = parse_training_labels("./train-labels-idx1-ubyte")
    
    test_images_int = parse_test_images("./t10k-images-idx3-ubyte")
    test_labels     = parse_test_labels("./t10k-labels-idx1-ubyte")
    
    ! Normalize the images, integer (0--255) -> real (0.0--1.0)
    training_images = real(training_images_int) / 255.0
    test_images     = real(    test_images_int) / 255.0
    
    ! Print elements in some images for example
    print '(A)', "Training set image 1"
    print '(A, I2)', "Label: ", training_labels(1)
    
    print '(*(28(I4), /))'  , training_images_int(:, 1)
    print '(*(28(F4.1), /))',     training_images(:, 1)
    
    print '(A)', "Test set image 2"
    print '(A, I2)', "Label: ", test_labels(2)
    
    print '(*(28(I4), /))'  , test_images_int(:, 2)
    print '(*(28(F4.1), /))',     test_images(:, 2)
    
    ! Convert an image data from 1D array to 2D
    image_2d = reshape(test_images(:, 2), IMAGE_DIMENSION)
    
    do i = 1, ROW_COUNT
        print '(28(F4.1))', image_2d(:, i)
    end do
end program main

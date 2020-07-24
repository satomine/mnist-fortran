! Fortran MNIST parser
!
! Convert binary data into default integers (without normalization)
!
! This module uses `convert = 'big_endian'` specifier in `open` statement
! It is implemented in GNU Fortran 9.3.0, but not specified in the Fortran standards
!
! TODO: Handle errors such as file-not-found and end-of-file
! TODO: Validate the header of an input file

module mnist
    use, intrinsic :: iso_fortran_env
    implicit none
    
    ! Define the dataset sizes as compile-time constants (They will rarely be changed)
    integer, parameter :: TRAINING_IMAGE_COUNT = 60000
    integer, parameter ::     TEST_IMAGE_COUNT = 10000
    
    integer, parameter ::        ROW_COUNT = 28
    integer, parameter ::     COLUMN_COUNT = 28
    integer, parameter :: PIXELS_PER_IMAGE = ROW_COUNT * COLUMN_COUNT
    
    ! Pixels in an MNIST image are in row-major order
    integer, parameter :: IMAGE_DIMENSION(2) = [COLUMN_COUNT, ROW_COUNT]
    
    public  :: parse_training_images, parse_test_images, &
    &          parse_training_labels, parse_test_labels
    
    private :: parse_images, parse_labels
    
contains
    function parse_training_images(file_name) result (images)
        character(*), intent(in) :: file_name
        integer                  :: images(PIXELS_PER_IMAGE, TRAINING_IMAGE_COUNT)
        
        images = parse_images(file_name, TRAINING_IMAGE_COUNT)
    end function parse_training_images
    
    function parse_test_images(file_name) result (images)
        character(*), intent(in) :: file_name
        integer                  :: images(PIXELS_PER_IMAGE, TEST_IMAGE_COUNT)
        
        images = parse_images(file_name, TEST_IMAGE_COUNT)
    end function parse_test_images
    
    function parse_training_labels(file_name) result (labels)
        character(*), intent(in) :: file_name
        integer                  :: labels(TRAINING_IMAGE_COUNT)
        
        labels = parse_labels(file_name, TRAINING_IMAGE_COUNT)
    end function parse_training_labels
    
    function parse_test_labels(file_name) result (labels)
        character(*), intent(in) :: file_name
        integer                  :: labels(TEST_IMAGE_COUNT)
        
        labels = parse_labels(file_name, TEST_IMAGE_COUNT)
    end function parse_test_labels
    
    function parse_images(file_name, expected_item_count) result (images)
        character(*), intent(in) :: file_name
        integer     , intent(in) :: expected_item_count
        integer                  :: images(PIXELS_PER_IMAGE, expected_item_count)
        
        integer(INT32) :: magic_number
        integer(INT32) :: item_count
        integer(INT32) :: row_count
        integer(INT32) :: column_count
        integer(INT8)  :: images_int8(PIXELS_PER_IMAGE, expected_item_count)
        
        integer :: unit
        
        open (newunit = unit, file = file_name, action = 'read', form = 'unformatted', &
        &     access = 'stream', status = 'old', convert = 'big_endian')
        
        read (unit) magic_number, item_count, row_count, column_count, images_int8
        close (unit)
        
        images = iand(int(images_int8), 255)  ! unsigned 8-bit integer -> default integer
    end function parse_images
    
    function parse_labels(file_name, expected_item_count) result (labels)
        character(*), intent(in) :: file_name
        integer,      intent(in) :: expected_item_count
        integer                  :: labels(expected_item_count)
        
        integer(INT32) :: magic_number
        integer(INT32) :: item_count
        integer(INT8)  :: labels_uint8(expected_item_count)
        integer :: unit
        
        open (newunit = unit, file = file_name, action = 'read', form = 'unformatted', &
        &     access = 'stream', status = 'old', convert = 'big_endian')
        
        read (unit) magic_number, item_count, labels_uint8
        close (unit)
        
        labels = int(labels_uint8)  ! unsigned 8-bit integer (up to 127) -> default integer
    end function parse_labels
end module mnist

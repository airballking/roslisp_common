(in-package :cl-transforms)

(defclass pose ()
  ((origin :type point :reader origin :initarg :origin)
   (orientation :type quaternion :reader orientation :initarg :orientation))
  (:documentation "Represents a 6 dof pose, consisting of an origin in R^3 and an orientation, represented as a quaternion"))

(defun make-pose (origin orientation)
  (make-instance 'pose :origin origin :orientation orientation))

(defmethod print-object ((obj pose) strm)
  (print-unreadable-object (obj strm :type t)
    (with-slots (origin orientation) obj
      (format strm "~{~<~%   ~a~>~}" (list origin orientation)))))

(defun make-2d-pose (x y theta)
  (make-pose (make-3d-vector x y 0.0)
             (axis-angle->quaternion (make-3d-vector 0 0 1) theta)))

(defun reference-transform (pose)
  "Return the transform that takes in the coordinates of a point in the pose's frame, and returns the coordinates in the reference frame"
  (make-transform (origin pose) (orientation pose)))

(defun transformed-identity (tr)
  "return the result of transforming the identity pose by a transform"
  (make-pose (translation tr) (rotation tr)))

(defun transform-pose (tr p)
  (transformed-identity (transform* tr (reference-transform p))))
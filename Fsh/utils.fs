module utils

// /// single coordinate
// type Coord =
//     | F of float32
//     | I of int
//
// /// 2D point (on flat surface)
// type Point2D = Coord * Coord
//
// /// 3D point
// type Point3D = Coord * Coord * Coord
//
// /// Point variant
// type Point =
//     | Point2D
//     | Point3D

type Point = float32 * float32 * float32

type Line = Point * Point

type Poly = List<Point>

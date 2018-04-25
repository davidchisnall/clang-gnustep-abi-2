// REQUIRES: x86-registered-target

// RUN: %clang_cc1 -triple x86_64-macho -emit-llvm -o %t %s
// RUN: FileCheck --check-prefix=CHECK-NEXT < %t %s

// Check that we set alignment 1 on the string.
//
// CHECK-NEXT: @.str = {{.*}}constant [13 x i8] c"Hello World!\00", section "__TEXT,__cstring,cstring_literals", align 1

// RUN: %clang_cc1 -triple x86_64-macho -fobjc-runtime=gcc -emit-llvm -o %t %s
// RUN: FileCheck --check-prefix=CHECK-GNU < %t %s
// CHECK-GNU: NXConstantString

// RUN: %clang_cc1 -triple x86_64-macho -fobjc-runtime=gcc -fconstant-string-class NSConstantString -emit-llvm -o %t %s
// RUN: FileCheck --check-prefix=CHECK-GNU-WITH-CLASS < %t %s
// CHECK-GNU-WITH-CLASS: NSConstantString
//
// RUN: %clang_cc1 -triple x86_64-unknown-freebsd -fobjc-runtime=gnustep-2.0 -emit-llvm -o %t %s
// RUN: FileCheck --check-prefix=CHECK-GNUSTEP2 < %t %s

// CHECK-GNUSTEP2: @_OBJC_CLASS_NSConstantString = external global i8*
// @0 = private unnamed_addr constant [13 x i8] c"Hello World!\00", align 1
// @".objc_str_Hello World!" = hidden global { i8**, i32, i32, i32, i32, i8* } { i8** @_OBJC_CLASS_NSConstantString, i32 0, i32 12, i32 12, i32 0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @0, i64 0, i64 0) }, section "__objc_constant_string", comdat, align 8

id a = @"Hello World!";


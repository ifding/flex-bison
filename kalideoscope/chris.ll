target triple = "i386-pc-linux-gnu"

define i32 @mul_add(i32 %x, i32 %y, i32 %z) {
entry:
  %tmp = mul i32 %x, %y
  %tmp2 = add i32 %tmp, %z
  ret i32 %tmp2
}

@.str = private constant [18 x i8] c"hello, world %d!\0A\00"

define i32 @main() {
entry:
  %str = getelementptr inbounds [18 x i8]* @.str, i32 0, i32 0
  %foo = call i32 @mul_add(i32 2, i32 4, i32 8)
  %call = call i32 (i8*, ...)* 
  @printf(i8* %str, i32 %foo)
  ret i32 1
}

declare i32 @printf(i8*, ...)

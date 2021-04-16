package module

func reverseString(s string) string {
	// 将字符串转换为 rune 类型的切片，并对该切片翻转
	res := reverse([]int32(s))
	// 再把 rune 类型的切片转为 string
	return string(res)
}

func reverse(s []int32) []rune {
	// 左右指针，对切片依次翻转
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
	return s
}

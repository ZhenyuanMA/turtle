#!/bin/bash

echo "This is Pick-the-Turtle Game"

function transfer {
	ranks=(A K Q J T 9 8 7 6 5 4 3 2)
	suits=(S H D C)
	rank=$((($1 - 1) / 4))
	suit=$((($1 - 1) % 4))
	eval $2=${suits[suit]}${ranks[rank]}
}

declare -a hands
declare -a remains
a=1

while [ $a -le 13 ]; do
	random=$(((RANDOM % 52) + 1))
	for ((i=0; i<=${#hands[*]}; i++)); do
		if [[ ${hands[i]} -eq $random ]]; then
			continue 2
		fi
	done
	num=${#hands[*]}
	hands[num]=$random
	a=$((a+1))
done

echo -n "The hand is "
for i in {0..12}; do
	transfer ${hands[i]} cards
	echo -n "$cards "
done
echo ""

for i in {0..12}; do
	num=${hands[i]}
	count=$i
	let j=i+1
	for (($j; j<=12; j++)); do
		if [[ ${hands[j]} -le $num ]]; then
			num=${hands[j]}
			count=$j
		fi
	done
	hands[$count]=${hands[i]}
	hands[i]=$num
done

echo -n "Sorted hand "
for i in {0..12}; do
	transfer ${hands[i]} cards
	echo -n "$cards "
done
echo ""

pair=0
for k in {0..12}; do
	declare -a temp
	for i in {0..12}; do
		rank=$(((${hands[i]} - 1) / 4))
		if [[ $rank -eq $k ]]; then
			num=${#temp[*]}
			temp[$num]=${hands[i]}
		fi
	done
	#echo ${#temp[*]}
	case ${#temp[*]} in
		4)
			let pair=pair+2;;
		3)
			remain=10
			for i in {0..3}; do
				suit=$(((${temp[i]} - 1) % 4))
				let remain=remain-suit-1
			done
			#echo $remain
			case $remain in
				4)
					num=${#remains[*]}
					remains[$num]=${temp[0]};;
				3)
					num=${#remains[*]}
					remains[$num]=${temp[1]};;
				2)
					num=${#remains[*]}
					remains[$num]=${temp[1]};;
				1)
					num=${#remains[*]}
					remains[$num]=${temp[2]};;
			esac
			let pair=pair+1;;
		2)
			let pair=pair+1;;
		1)
			num=${#remains[*]}
			remains[$num]=${temp[0]};;
		0)
	esac
	#suit=$((($1 - 1) % 4))
	unset temp
done

echo -n "Remaining cards "
for ((i=0; i<${#remains[*]}; i++)); do
	transfer ${remains[i]} cards
	echo -n "$cards "
done
echo "" 

echo "Number of pairs eliminated $pair "

echo "Number of remaining cards ${#remains[*]}"




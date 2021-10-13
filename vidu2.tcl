#B1: Tao doi tuong mo phong
set ns [new Simulator]

#Dinh nghia luong du lieu cho NAM
# fid_ = ...
$ns color 1 Green
$ns color 2 Red

#B2: tao file luu vet
set tf [open vidu2.tr w]
$ns trace-all $tf

set nf [open vidu2.nam w]
$ns namtrace-all $nf

# dinh nghia thu tuc ket thuc
proc ket {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam vidu2.nam &
exit 0
}

#B3: Thiet lap mang
#Tao cac node
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#Tao lien ket giua cac node

$ns duplex-link $n0 $n2 3Mb 12ms DropTail
$ns duplex-link $n1 $n2 3Mb 12ms DropTail
$ns duplex-link $n2 $n3 2.5Mb 15ms DropTail
$ns duplex-link $n3 $n4 3Mb 12ms DropTail

# Thiet lap kich thuoc hang doi la 10 cho lien ket n2-n3 va n3-n4
$ns queue-limit $n2 $n3 10
#$ns queue-limit $n3 $n4 10

# Xac dinh vi tri cac node (cho NAM)
$ns duplex-link-op $n0 $n2 orient up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n2 $n3 queuePos 0.5

#B4+B5: Thiet lap cac ket noi TCP, tuon luu luong tren mang
#TCP Reno: Dieu chinh kich thuoc cua so de dieu khien tac nghen
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1
$tcp0 set packetSize_ 1009

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1
$tcp0 set fid_ 2
$tcp0 set packetSize_ 1009

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#B6: Xac dinh thoi gian mo phong can thiet

$ns at 0.5 "$ftp0 start"
$ns at 1.5 "$ftp1 start"
$ns at 6.0 "$ftp0 stop"
$ns at 7.5 "$ftp1 stop"

$ns at 8.0 "ket"
$ns run


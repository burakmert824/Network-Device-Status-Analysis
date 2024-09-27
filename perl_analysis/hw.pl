#!/usr/bin/perl
use strict; 
use warnings;

my $file = "Cards.csv";
open (my $data , '<', $file) or die "Could not open '$file' $!\n";
my $isFirst = 1;

=begin
#hashmap for 

#hashmap acilacak hasmap keyleri var mi diye checklenicek
=cut

my @cards = ();

my %statistics = (
    "total_devices" => 0,
    "total_cards" => 0,
    "max_card_temperature" => 0,
    "hottest_card_device" => "empty"
);

my %devices;

while (my $line = <$data>) {
    print "isFirst $isFirst\n";
    print "line $line\n";
    chomp $line;
    if($isFirst == 1){
        $isFirst = 0;
        next;
    }
    my @arra = split(/;/, $line);
    
    if(exists $devices{$arra[0]}){
        # handle statistics without increasing device count

        # check if its temperature is higher than the max_card_temperature
        if($arra[2] > $statistics{"max_card_temperature"}){
            $statistics{"max_card_temperature"} = $arra[2];
            $statistics{"hottest_card_device"} = $arra[1]."/".$arra[0];
        }
        # increase total cards
        $statistics{"total_cards"} = $statistics{"total_cards"} + 1;

        # check if its temperature is higher than 70
        if($arra[2] > 70){
            $devices{$arra[0]}{"high_temp_cards_count"} = $devices{$arra[0]}{"high_temp_cards_count"} + 1;
        }

        # increase card count of device
        $devices{$arra[0]}{"card_count"} = $devices{$arra[0]}{"card_count"} + 1;

        # calculate new sum of temprature
        $devices{$arra[0]}{"sum_of_temperatures"} = $devices{$arra[0]}{"sum_of_temperatures"} + $arra[2];

        # calculate new average temperature
        $devices{$arra[0]}{"average_temperature"} = $devices{$arra[0]}{"sum_of_temperatures"} / $devices{$arra[0]}{"card_count"};

        # check if its temperature is higher than the max_temperature of device
        if($arra[2] > $devices{$arra[0]}{"max_temperature"}){
            $devices{$arra[0]}{"max_temperature"} = $arra[2];
        }
        
    }else{
        # handle statistics
        # increase device count
        $statistics{"total_devices"} = $statistics{"total_devices"} + 1;

        # check if its temperature is higher than the max_card_temperature
        if($arra[2] > $statistics{"max_card_temperature"}){
            $statistics{"max_card_temperature"} = $arra[2];
            $statistics{"hottest_card_device"} = $arra[1]."/".$arra[0];
        }
        # increase total cards
        $statistics{"total_cards"} = $statistics{"total_cards"} + 1;

        # add device to devices hashmap
        my $new_device_hash = {
            "name" => $arra[0],
            "card_count" => 1,
            "max_temperature" => $arra[2],
            "high_temp_cards_count" => $arra[2] > 70 ? 1 : 0,
            "average_temperature" => $arra[2],
            "sum_of_temperatures" => $arra[2],   
        };

        $devices{$arra[0]} = $new_device_hash;

    }
}

my @device_names = keys %devices;

# generating html part

my $summary_table = "
    <table border=\"1\">
        <tr><td>Total Devices</td><td>$statistics{\"total_devices\"}</td></tr>
        <tr><td>Total Cards</td><td>$statistics{\"total_cards\"}</td></tr>
        <tr><td>Max Card Temperature</td><td>$statistics{\"max_card_temperature\"}</td></tr>
        <tr><td>Hottest Card / Device</td><td>$statistics{\"hottest_card_device\"}</td></tr>
    </table>
";

print "\n------Summary Table------\n";
print $summary_table;


my $rows = "";
foreach my $device (values %devices) {
    $rows .= "
        <tr>
            <td>$device->{name}</td>
            <td>$device->{card_count}</td>
            <td>$device->{high_temp_cards_count}</td>
            <td>$device->{max_temperature}</td>
            <td>" . int($device->{average_temperature}) . "</td>
        </tr>
    ";
}


my $devices_table = "
    <table border=\"1\">
        <tr>
            <td>Device</td>
            <td>Total # of Cards</td>
            <td>High Temp. Cards #</td>
            <td>Max. Temperature</td>
            <td>Avg. Temperature</td>
        </tr>
        " . $rows . "
    </table>
";

my $html_content = "
    <!DOCTYPE html>
    <html>
    <head>
        <title>Device Report</title>
    </head>
    <body>
        <h1>Summary</h1>
        $summary_table
        <h1>Devices</h1>
        $devices_table
        <p>(High Temperature >= 70)</p>
    </body>
    </html>
";

open(my $fh, '>', 'Devices.html') or die "Could not open file 'device_report.html' $!";
print $fh $html_content;
close $fh;
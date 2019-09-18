#!/usr/bin/perl

use strict;
use warnings;

use Term::Prompt;
use Acme::Dice qw(roll_dice roll_craps);

start_screen();

sub start_screen {
  print "================================\nDICE MENU\n-------------------------------\n";
  my $users_die = prompt(
    'm',
    {
      prompt           => 'My die is: ',
      title            => '',
      items            => [ qw (d4 d6 d8 d10 d12 d20 advanced cheat quit) ],
      order            => 'across',
      rows             => 9,
      cols             => 1,
      display_base     => 1,
      return_base      => 0,
      accept_multiple_selections => 0,
      accept_empty_selection     => 0,
      ignore_whitespace => 1,
      separator         => '[,/\s]',
      ignore_empties    => 1
    },
    'Choose an option',
    ''
  );

  if(    $users_die <  6 ){fixed_dice_rolling($users_die);}
  elsif( $users_die == 6 ){custom_dice_rolling();}
  elsif( $users_die == 7 ){loaded_dice_rolling();}
  elsif( $users_die == 8 ){exit;}
  else{print "You are too young for this\n";exit;}
}


sub custom_dice_rolling {
  print "(DnD style, e.g. 3d10): ";
  my $custom = <STDIN>;
  my ($number, $sides) = $custom =~ /(\d+)/g;
  do {
    my @dice = roll_dice( dice => $number, sides => $sides);
    print SumArryEvl( @dice ).': '.join('-', @dice)."\n";
  } while (prompt('y', 'Roll again? ', '', 'y'));
  start_screen();
}

sub loaded_dice_rolling {
  print "(DnD style, e.g. 3d10,favor,bias): ";
  my $custom = <STDIN>;
  my ($number, $sides, $target, $handicap) = $custom =~ /(\d+)/g;
  do {
    my @dice = roll_dice( dice => $number, sides => $sides, favor => $target, bias => $handicap);
    print SumArryEvl( @dice ).': '.join('-', @dice)."\n";
  } while (prompt('y', 'Roll again? ', '', 'y'));
  start_screen();
}

sub fixed_dice_rolling {
  my $die = 0;
  if(   $_[0] == 0) {$die = 4;}
  elsif($_[0] == 1) {$die = 6;}
  elsif($_[0] == 2) {$die = 8;}
  elsif($_[0] == 3) {$die = 10;}
  elsif($_[0] == 4) {$die = 12;}
  elsif($_[0] == 5) {$die = 20;}
  do {
    my $total = roll_dice( dice => 1, sides => $die);
    print "1d".$die.": $total\n";
  } while (prompt('y', 'Roll again? ', '', 'y'));
  start_screen();
}

sub SumArryEvl { eval join "+", @_ }
requires 'perl', '5.008001';
requires 'Class::Accessor::Lite', '0.04';
requires 'List::MoreUtils';
requires 'Proc::Wait3', '0.03';
requires 'Scope::Guard';
requires 'Signal::Mask';

on test => sub {
    requires 'Test::Requires';
    requires 'Test::SharedFork';
};

kdb+tick 2.4 is now available to licensed tick users from http://kxdownloads.com

It is a port of kdb+tick 2.3 to q, with no additional functionality,
and hence is a drop in replacement for kdb+tick 2.3, with the
IMPORTANT
exception that calling & monitoring scripts will need to be updated
to reflect the file extension change to .q from .k.

The motivation for the release is to make it easier for users to understand tick.

As q and k compile to the same bytecode, there is no performance impact.

The documentation at http://www.kx.com/q/d/tick.htm has been updated accordingly.

# Laptop utils

Varios utils for linux-powered laptops.

## Installation

```
git clone https://github.com/tataranovich/laptop-utils.git
cd laptop-utils
sudo make install
```

## Usage

Scripts adopted for Dell Latitude laptops. But I believe them can be helpfull for any other laptop.

### Hibernate after suspend

You need to install pm-utils first. Next you need to set appropriate value for AUTO_HIBERNATE variable in /etc/default/laptop-utils. This variable control how much seconds will pass before laptop will hibernate after suspend.

### Dell dock support

At work and at home I'm using port replicators. So I wrote a script which is aware how to control external displays and my input preferences. I do not like point stick and prefer to disable touchpad if external mouse connected.

To use this functionality set appropriate values for LCDPANEL, TOUCHPAD and STICK variables in /etc/default/laptop-utils.

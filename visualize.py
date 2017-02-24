#!/usr/local/bin/python3.5

import matplotlib.pyplot as plt
from dateutil.parser import parse

days = []
time_spent = []
with open('stats.txt') as f:
    for line in f:
        date, _time_spent = line.split(': ')
        hours, minutes, seconds = [int(x) for x in _time_spent.split(':')]
        days.append(parse(date))
        time_spent.append(hours + minutes/60.0 + seconds/(60.0*60.0))

    plt.plot(days, time_spent, 'ro-')
    plt.ylabel('hours spent per day')
    plt.show()

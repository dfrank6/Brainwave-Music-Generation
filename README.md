# Brain-Wave-Music-Generation

This is an ongoing multi-disciplinary collaborative project through Georgia Tech starting November 2021 and continuing to present.

We are innovating new ways to integrate science and art by using a consumer-grade brain computer interface (Muse https://choosemuse.com/) to convert a scientist's or artist's brainwaves into music and have someone dance to them.


I am collaborating with the following people:

Professor - Dr. Francesco Fedele https://ce.gatech.edu/directory/person/francesco-fedele

Music Technologist - Dr. Mike Winters https://mikewinters.io/about-me/

Painter - Rachel Grant https://www.rachelgrantstudio.com/

Dancer - Bella Dorado https://www.belladorado.com/


My role is to convert the raw brainwave data from the Muse into music. I did this by researching what each brainwave means and writing code to deliberately connect each to an appropriate element of the music (such as bass, harmony, melody, etc.).

During performances, I set up the signal flow as such: the signal from the Muse is connected by Bluetooth to one's personal device. This signal is sent to SuperCollider through the local network. SuperCollider is an audio synthesis platform on which I wrote the code to transform the signal into music. This signal is then sent through a MIDI-bus to Ableton which generates selected soundscapes.

There are two versions of the code here:

med - the intensity of the music depends on the amplitude of the brainwaves of a single person wearing a Muse

song 2 - the intensity of the music depends on the harmony of the brainwaves of two people who are each wearing a Muse

I've included an audio sample of med, and be sure to check out our performance here:

https://www.youtube.com/watch?v=ZB7Gk1lVZFM

And here are some past clips: 

https://www.youtube.com/watch?v=jU2PflnULj0

https://www.youtube.com/shorts/jL8k0ehb7eQ

Enjoy! :)

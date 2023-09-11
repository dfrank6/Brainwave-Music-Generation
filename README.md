# Brain-Wave-Music-Generation

This is an ongoing multi-disciplinary collaborative project through Georgia Tech starting November 2021 and continuing to present.

We are innovating new ways to integrate science and art by using a consumer-grade brain computer interface (Muse https://choosemuse.com/) to convert brainwaves into music and have people make art to them.


I am collaborating with the following people:

Professor - Dr. Francesco Fedele https://ce.gatech.edu/directory/person/francesco-fedele

Music Technologist - Dr. Mike Winters https://mikewinters.io/about-me/

Painter - Rachel Grant https://www.rachelgrantstudio.com/

Dancer - Bella Dorado https://www.belladorado.com/

Georgia Tech Neuroscience Student and Painter - Tanisha Chanda https://tanishachanda.wixsite.com/portfolio/bio


My role is to convert the raw brainwave data from the Muse into music. I did this by researching what each brainwave means and writing code to deliberately connect each to an appropriate element of the music (such as bass, harmony, melody, etc.).

During performances, I set up the signal flow as such: the signal from the Muse is connected by Bluetooth to one's personal device. This signal is sent to SuperCollider through the local network. SuperCollider is an audio synthesis platform on which I wrote the code to transform the signal into music. This signal is then sent through a MIDI-bus to Ableton which generates selected soundscapes.

There are two versions of the code here:

med - the intensity of the music depends on the amplitude of the brainwaves of a single person wearing a Muse

song 2 - the intensity of the music depends on the harmony of the brainwaves of two people who are each wearing a Muse

Hear a sample of the music in **med_sample.mp3**, and check out our performances here:

2022: https://www.youtube.com/watch?v=ZB7Gk1lVZFM

2023: https://www.youtube.com/watch?v=OFLOn6fzMKY

Enjoy! :)

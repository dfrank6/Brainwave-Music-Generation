# Brain-Wave-Music-Generation

This is a multi-disciplinary project at Georgia Tech from November 2021 to present.

We are using a consumer-grade brain computer interface (https://choosemuse.com/) to convert brainwaves into music and have artists create to the sounds from their mind.


I am collaborating with the following people:

Professor - Dr. Francesco Fedele https://ce.gatech.edu/directory/person/francesco-fedele

Music Technologist - Dr. Mike Winters https://mikewinters.io/about-me/

Painter - Rachel Grant https://www.rachelgrantstudio.com/

Dancer - Bella Dorado https://www.belladorado.com/

Georgia Tech Neuroscience Student and Painter - Tanisha Chanda https://tanishachanda.wixsite.com/portfolio/bio


My role is to convert the live brainwave data into music. I did this by researching what each brainwave means and writing code to connect each to an appropriate element of the music (bass, harmony, melody, etc.) using SuperCollider (https://supercollider.github.io/).

During performances, I set up the signal flow as follows: the signal from the Muse is connected by Bluetooth to one's phone. This signal is sent to SuperCollider over a local network. This signal is then sent through a MIDI-bus to Ableton which generates defined soundscapes.

There are two versions of the code here:

med - the intensity of the music depends on the amplitude of the brainwaves of a single person wearing a Muse

song 2 - the intensity of the music depends on the harmony of the brainwaves of two people who are each wearing a Muse

You can hear a sample of the music in **med_sample.mp3** and also check out our performances here:

2022: https://www.youtube.com/watch?v=ZB7Gk1lVZFM

2023: https://www.youtube.com/watch?v=OFLOn6fzMKY

Thanks for stopping by!

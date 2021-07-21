# dti_demos

This is your README. It will tell you what to do. When in doubt,
always look at the README!

Today, you will do some hands-on learning to get to know a little better 
the processes behind DTI, as well as the Discovery Cluster, SLURM, and, 
of course, Linux.

#####WELCOME TO THE FUN PART#####

You are going to run the first three steps of DTI -- eddy, fslroi, and BET!
Do you remember what they do? 

You have in your folder the raw subject data of the identifying 
subject number you chose. If you want to know what a raw brain looks 
like in ASCII text, type ' cat [sub-file-name] ' and hit enter... but 
only if you're very brave. 

If you realized you've opened the gates to You Know Not Where, 
press Ctrl+C (Cmd+C on Mac) to safely escape. 

Hmm, if only there were a better way to view the brain... 


Aha! 

######FSLEYES#####

Pop back into OOD and see if you can find FSL. It's under the 
Interactive Apps menu. 

Once you launch, you'll be presented with a pulldown menu. Click 
"FSLEYES" to launch the state-of-the-art(ish) FSL viewer! 

Press Ctrl+O (Cmd+O) to open a file. Using the search bar, 
navigate to your special directory (hint: if you don't remember
where it is, go back to terminal and type ' pwd ' and press enter. 
It stands for ' Present Working Directory ' and will tell you 
exactly where you are. 

Pull up the subject data and give it a good look. Hmm, it's a little
murky, and there's a skull (plus maybe some eyes if you're lucky) and,
depending on the subject, a level of distortion caused by movement in 
the scanner. What can we do about that? 

Good news! Our fsl commands will help. 

#####EDDY AND BET... VIA SBATCH#####

To get started, we need to create an fsl-frienly environment. Do 
do this, enter the command ' module load fsl/6.0.3-cuda9.1 '. 
Make sure it's loaded by entering ' module list ' after. It 
should show up! 

Now, let's start running some commands. Before we do, though, a 
quick note on how linux processes work. 

If we start a process (a program + allocated memory, stack, etc)
via the command line, it will run until terminated-- 
and leaving//signing off will do that. So what if our process 
takes 79 hours?! Can we leave our computer on for that long? 

Hmm... maybe a better solution is to send the process to a computer 
that ALWAYS stays on and will do it for us so we can sleep and exercise and
take care of babies. To do this, we use the SLURM system that's built into
the cluster. (Really, the cluster is just a bunch of computers, linked 
together, which are really, really good at math. And at the end of the day,
everything we do is just lots and lots of layers of... you guessed it... math.


So, instead of typing "eddy_correct [blah] [blah] [etc], let's write a 
script that does it for us! We can SBATCH (Submit Batch) the script and 
go have some coffee while a computer in cluster-land plugs away at the 
job. 

This might be your first shell script. It also very well might not. But, 
either way, let's go over the (surprisingly few) steps we'll take to 
SBATCH our job. 


#####THE FIRST SCRIPT#####

Start by opening a new file with the editor of your choice. Name it
something along the lines of "eddy_script.bash" or "eddy_correct.sh."
All that's important is it ends with .bash or .sh. 

Hop on into it and start edit mode//insert mode//whatever your editor
supports. 

If you don't know how to do either of the two previous steps, ask a
friend for help! 

Let's get our boilerplate out of the way. One nice thing about bash
(the language of Linux) is that it has very little 'boilerplate code,'
or code at the beginning of a script to tell the computer with which
language to interpret the script. All we need to type is 
#!/bin/bash 

at the very top. Make sure it's exact. 
For context, HTML (the language that makes web pages run) boilerplate 
can easily reach 30 lines... and that's before writing any real "code."

Now that we've told the computer this is a shell script with the 
.bash or .sh extension and the #!/bin/bash header, we can start writing
our code. 

Bash is a very low-level language, which does not mean it's for beginners.
It means it works very close to the computer and machinery itself. This 
means we can easily execute command line commands within any shell script. 
By the way, "shell script" and "bash script" are mostly interchangeable. 

So, without further ado, let's get to the commands. 

#####THE COMMANDS#####
We need to run eddy. The command for this is eddy_correct, and it takes
at base 3 arguments: an input file, a user-specified output file, and 
the volume number for the reference volume that will be used as a target 
to which to register all other volumes. The default for this is 0, which 
signifies the first volume. 0 means 1 in Computer Talk (except when it 
totally doesn't). Anyway, it looks like our command is not very complicated. 

Let's write it: 

eddy_correct [input] [output] 0

where [input] is the raw subject data and output is whatever you want to 
call the output. This can be anything, though it makes sense to call it 
something like "eddy_output" or something to that effect. It should 
look a bit like this: 

eddy_correct sub-003.dwi.nii.gz eddy_correct_out 0


And that's it. Now let's run! Go ahead and exit the script and type 
' sbatch [script name] ' and press enter. You can type ' sq ' to look 
at your script in the queue; an R next to it means it's running! 
Use ' cat slurm-[long number] ' to see the output of your script. 

...

... 

...

Are we forgetting something? You can certainly run this script, but it 
will probably return a slurm outfile (basically the output of the
computer where the process ends up being ran) that says something like 
"bash: eddy_correct: command not found." Why is this? 


#####THE TRICK TO IT##### 

Do you remember that we loaded fsl as a module into our native workspace?
Well, now our native workspace knows that any fsl command, like eddy_correct,
bet2, fslroi, or anything of the like isn't total gibberish or bad input. 
But the computer we're sending the job to has ~no idea~ what fsl is until 
we tell it! This is why it's important to keep track of what machine you're
working on and to remember that every time you send a job off via sbatch, you 
have the job load all necessary modules before it performs any commands. 
Think of it like using your computer to sign into another device remotely and
trying to use some custom touchpad commands. Until you tell that computer to 
recognize those (say, by writing them into that machine's System Preferences),
it will not know what to do.

So, after the #!/bin/bash but before anything else, let's type our module load
command: 

module load fsl/6.0.3-cuda9.1 

add another line that says 

export FSLOUTPUTTYPE=NIFTI_GZ

to make sure we get the desired output file type. 

Oh, and we also need to tell the computer WHERE to run the command! 

In terminal, use the ' pwd ' command to get your path and in the script, 
type 

cd [output of pwd]

it should look like 

cd /work/mindlab/Projects/mci/mci_dti/dti_demo_7-21/mydirectory

once we have that (and the eddy command underneath it), we're ACTUALLY done.

Now, we can sbatch and watch our happy little script run away!


You will notice, though, that the time counter will tick up... and up... and up.
Hmm. This may take a while. What to do while we wait?

#####IN THE MEANWHILE#####

The best thing to do while we wait for scripts to finish, I think, is to 
write more scripts. So, let's go ahead and do that. 

Actually, here's another idea, since we spent so much energy writing the first
script: Let's do a pure command to cooldown before we tackle our next program.

We're going to extract the b0 value from our subject file. To do this, we use 
fslroi. We already have the fsl module loaded in our native space... so can we
just run the command? 

Well, when we log on to the cluster, we start on a login node. This is a 
computer (node = physical computer unit) that we can do most of our 
file management and light work in. But for anything heavy --and fsl tends
to be pretty heavy-- we MUST use a compute node. Why? Imagine telling 
your home computer to do one billion prime factorizations, right now. 
It would not be happy. It might finish. But most likely it will complain
and maybe die. The login node is more powerful than your computer, 
but neither are in the same league as a compute node, which is built 
to handle LOTS of numbers. So, let's enter one! 

To sign in to a compute node, just type 

srun --pty /bin/bash 

into your terminal and press enter. It may take a minute, but when 
the @ood in your username changes to an @c-xxx, you're in. You now
have the full power of a cluster computer at your hands. 


#####POWER#####

Let's get right to it. 

The fslroi format is as follows:

fslroi [input] [output] [min_index] [min_size] 

For our intents and purposes, min_index and min_size 
will be 0 and 1, respectively. 

Your command should look like this: 

fslroi [sub-xxx].nii.gz dwi_b0_output 0 1

We don't need a script to send our command to a powerful
computer; we ARE that computer, and we can execute commands 
directly. 

And they will run very, very quickly, especially compared to on a 
login node. 
Note: If you every do accidentally run a high-intensity command 
on a login node, CANCEL IT IMMEDIATELY (CTRL+C//CMD+C). Otherwise,
you may alert the Research Computing Department, and if they notice you,
beware. 


Now we have our output. By the way, isn't our directory kind of full?
eddy makes lots (lots) of temporary files before giving us our nice, 
clean single-file output. 

How to escape from a messy directory? Write a script and nestle in, 
of course. 

Open a new file and call it bet2.sh or something like that. Slap on
your bash boilerplate on the top line and write the fsl module load +
export + cd commands from above (you can highlight text on OOD to automatically
copy it to your clipboard and use Ctrl+V//Cmd+V to paste as normal, which 
is not a luxury typically found in Linux.) 

Now for our bet2 (BET) command. 

bet2 takes the form: 

bet2 [input] [output] [commands]

The commands we'll run are ' -m ' and ' -f 0.1 '. -m generates a 
binary mask in addition to our output, while -f sets the fractional 
intensity threshold. A smaller value will yeild a larger brain outline 
estimate. 

Remember that the output is whatever we want to call it and the input
is (in this case) the output of fslroi, which is likely called 
dwi_b0_output.nii.gz , but if you specified a different output name
in your fslroi command, make sure you use that one. You can always 
copy-paste the filename from your directory. 

Try writing the command yourself before looking at the answer below. 




The command will look like: 

bet2 dwi_b0_output.nii.gz betoutput -m -f 0.1


All done. Exit the script and sbatch away. It won't take long.  
eddy might be done at this point, but it may still be finishing. 
We'll have to wait either way. 

Once everything is done (you'll know once your directory is 
clean and contains only a few files again), head over to FSLEYES
and look at some of the output files. What do you notice? 


#####(SADLY) THE END####

And here we reach the conclusion to our demonstration. Like all
good endings, though, it's the beginning of something new. DTI
is expansive and has many, many more steps, a few of which involve 
serious scripting and employment of the Cluster's powerful 
Parallel Computing capabilities. If you're interested in learning more,
come talk! 

And, by the way, you may have just written your first two computer 
programs... and in bash, a notoriously difficult language, at that. 
If so, congratulations!!! If not, maybe you gleaned some
insight into the deeper workings of the Cluster and High Performance
Computing. Either way, I hope you enjoyed today's activity. 

For now, that's all folks. 

Sincerely, 

Your README. 

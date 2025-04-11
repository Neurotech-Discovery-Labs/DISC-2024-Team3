#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2022.2.5),
    on April 02, 2025, at 14:34
If you publish work using this script the most relevant publication is:

    Peirce J, Gray JR, Simpson S, MacAskill M, Höchenberger R, Sogo H, Kastman E, Lindeløv JK. (2019) 
        PsychoPy2: Experiments in behavior made easy Behav Res 51: 195. 
        https://doi.org/10.3758/s13428-018-01193-y

"""

# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding

import psychopy.iohub as io
from psychopy.hardware import keyboard

# Run 'Before Experiment' code from LSL_setup
from pylsl import StreamInfo, StreamOutlet

# Create an LSL outlet for sending markers
info = StreamInfo(name='PsychoPyMarkers', type='Markers', channel_count=1, channel_format='float32', source_id='psycho_marker_stream')
outlet = StreamOutlet(info)
print("LSL outlet for PsychoPy markers initialized.")


# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)
# Store info about the experiment session
psychopyVersion = '2022.2.5'
expName = 'Team 3 Oddball no flashing (final!)'  # from the Builder filename that created this script
expInfo = {
    'participant': f"{randint(0, 999999):06.0f}",
    'session': '001',
}
# --- Show participant info dialog --
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='C:\\Users\\General Use\\Desktop\\NT Group 3 24-25\\Team 3 Oddball no flashing (final!)_lastrun.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

# Start Code - component code to be run after the window creation

# --- Setup the Window ---
win = visual.Window(
    size=[1920, 1080], fullscr=True, screen=0, 
    winType='pyglet', allowStencil=False,
    monitor='testMonitor', color=[-1,-1,-1], colorSpace='rgb',
    blendMode='avg', useFBO=True, 
    units='height')
win.mouseVisible = False
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess
# --- Setup input devices ---
ioConfig = {}

# Setup iohub keyboard
ioConfig['Keyboard'] = dict(use_keymap='psychopy')

ioSession = '1'
if 'session' in expInfo:
    ioSession = str(expInfo['session'])
ioServer = io.launchHubServer(window=win, **ioConfig)
eyetracker = None

# create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard(backend='iohub')

# --- Initialize components for Routine "introduction" ---
text_instr = visual.TextStim(win=win, name='text_instr',
    text="You will now be beginning our experiment. A lab member will be nearby at all times if you'd like to stop or run into any difficulties. You will have 1 break as well.",
    font='Arial',
    pos=(0, 0), height=0.04, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
image_next = visual.ImageStim(
    win=win,
    name='image_next', 
    image='next.png', mask=None, anchor='center',
    ori=0.0, pos=(0.6, -0.4), size=None,
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)
mouse = event.Mouse(win=win)
x, y = [None, None]
mouse.mouseClock = core.Clock()
# Run 'Begin Experiment' code from code_2
# Define your full greyscale images list using raw strings for Windows paths:
greyImagesList = [
    r"C:\Users\General Use\Desktop\NT Group 3 24-25\OASIS Neutrals\greyscale-007.jpg",
    r"C:\Users\General Use\Desktop\NT Group 3 24-25\OASIS Neutrals\greyscale-015.jpg",
    r"C:\Users\General Use\Desktop\NT Group 3 24-25\OASIS Neutrals\greyscale-136.jpg",
    r"C:\Users\General Use\Desktop\NT Group 3 24-25\OASIS Neutrals\greyscale-051.jpg",
    r"C:\Users\General Use\Desktop\NT Group 3 24-25\OASIS Neutrals\greyscale-142.jpg",
]


# --- Initialize components for Routine "outerloopcode" ---

# --- Initialize components for Routine "oddballroutine" ---
oddball_picture = visual.ImageStim(
    win=win,
    name='oddball_picture', 
    image='sin', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(0.5, 0.5),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)

# --- Initialize components for Routine "picture_delay" ---
text_2 = visual.TextStim(win=win, name='text_2',
    text=' ',
    font='Open Sans',
    pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-1.0);

# --- Initialize components for Routine "halfway_break" ---
text_instr_2 = visual.TextStim(win=win, name='text_instr_2',
    text="You've completed half of the experiment! Click next when you're ready to continue.",
    font='Arial',
    pos=(0, 0), height=0.04, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
image_next_2 = visual.ImageStim(
    win=win,
    name='image_next_2', 
    image='next.png', mask=None, anchor='center',
    ori=0.0, pos=(0.6, -0.4), size=None,
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)
mouse_2 = event.Mouse(win=win)
x, y = [None, None]
mouse_2.mouseClock = core.Clock()

# --- Initialize components for Routine "outerloopcode" ---

# --- Initialize components for Routine "oddballroutine" ---
oddball_picture = visual.ImageStim(
    win=win,
    name='oddball_picture', 
    image='sin', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(0.5, 0.5),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)

# --- Initialize components for Routine "picture_delay" ---
text_2 = visual.TextStim(win=win, name='text_2',
    text=' ',
    font='Open Sans',
    pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-1.0);

# --- Initialize components for Routine "thanks" ---
text = visual.TextStim(win=win, name='text',
    text='The experiment is now over. \n\nA lab member will be coming over to help you shortly. \n\nThank you!',
    font='Open Sans',
    pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 

# --- Prepare to start Routine "introduction" ---
continueRoutine = True
routineForceEnded = False
# update component parameters for each repeat
# setup some python lists for storing info about the mouse
mouse.x = []
mouse.y = []
mouse.leftButton = []
mouse.midButton = []
mouse.rightButton = []
mouse.time = []
mouse.clicked_name = []
gotValidClick = False  # until a click is received
# keep track of which components have finished
introductionComponents = [text_instr, image_next, mouse]
for thisComponent in introductionComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "introduction" ---
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_instr* updates
    if text_instr.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        text_instr.frameNStart = frameN  # exact frame index
        text_instr.tStart = t  # local t and not account for scr refresh
        text_instr.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(text_instr, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'text_instr.started')
        text_instr.setAutoDraw(True)
    
    # *image_next* updates
    if image_next.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        image_next.frameNStart = frameN  # exact frame index
        image_next.tStart = t  # local t and not account for scr refresh
        image_next.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(image_next, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'image_next.started')
        image_next.setAutoDraw(True)
    # *mouse* updates
    if mouse.status == NOT_STARTED and t >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        mouse.frameNStart = frameN  # exact frame index
        mouse.tStart = t  # local t and not account for scr refresh
        mouse.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(mouse, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.addData('mouse.started', t)
        mouse.status = STARTED
        mouse.mouseClock.reset()
        prevButtonState = mouse.getPressed()  # if button is down already this ISN'T a new click
    if mouse.status == STARTED:  # only update if started and not finished!
        buttons = mouse.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # check if the mouse was inside our 'clickable' objects
                gotValidClick = False
                try:
                    iter(image_next)
                    clickableList = image_next
                except:
                    clickableList = [image_next]
                for obj in clickableList:
                    if obj.contains(mouse):
                        gotValidClick = True
                        mouse.clicked_name.append(obj.name)
                x, y = mouse.getPos()
                mouse.x.append(x)
                mouse.y.append(y)
                buttons = mouse.getPressed()
                mouse.leftButton.append(buttons[0])
                mouse.midButton.append(buttons[1])
                mouse.rightButton.append(buttons[2])
                mouse.time.append(mouse.mouseClock.getTime())
                if gotValidClick:
                    continueRoutine = False  # abort routine on response
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in introductionComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "introduction" ---
for thisComponent in introductionComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# store data for thisExp (ExperimentHandler)
thisExp.addData('mouse.x', mouse.x)
thisExp.addData('mouse.y', mouse.y)
thisExp.addData('mouse.leftButton', mouse.leftButton)
thisExp.addData('mouse.midButton', mouse.midButton)
thisExp.addData('mouse.rightButton', mouse.rightButton)
thisExp.addData('mouse.time', mouse.time)
thisExp.addData('mouse.clicked_name', mouse.clicked_name)
thisExp.nextEntry()
# the Routine "introduction" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
Stimulus_Trials = data.TrialHandler(nReps=3.0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('ODDBALL Picture Set/Oddball Target Paths.xlsx'),
    seed=None, name='Stimulus_Trials')
thisExp.addLoop(Stimulus_Trials)  # add the loop to the experiment
thisStimulus_Trial = Stimulus_Trials.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisStimulus_Trial.rgb)
if thisStimulus_Trial != None:
    for paramName in thisStimulus_Trial:
        exec('{} = thisStimulus_Trial[paramName]'.format(paramName))

for thisStimulus_Trial in Stimulus_Trials:
    currentLoop = Stimulus_Trials
    # abbreviate parameter names if possible (e.g. rgb = thisStimulus_Trial.rgb)
    if thisStimulus_Trial != None:
        for paramName in thisStimulus_Trial:
            exec('{} = thisStimulus_Trial[paramName]'.format(paramName))
    
    # --- Prepare to start Routine "outerloopcode" ---
    continueRoutine = True
    routineForceEnded = False
    # update component parameters for each repeat
    # Run 'Begin Routine' code from code_3
    import random
    
    # For using all 19 greyscale images:
    totalGreyscale = len(greyImagesList)  # should be 19
    totalSlots = totalGreyscale + 1       # 19 + 1 = 20
    
    # Randomly choose a slot for the oddball image (0-indexed)
    oddball_index = random.randint(1, totalSlots - 1)
    
    # Create the list of images for this outer trial:
    trialImages = greyImagesList.copy()  # Make a copy of the greyscale list
    trialImages.insert(oddball_index, ImagePath)  # Insert oddball at random position
    
    # Initialize the counter for the inner loop:
    inner_index = 0
    # keep track of which components have finished
    outerloopcodeComponents = []
    for thisComponent in outerloopcodeComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "outerloopcode" ---
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in outerloopcodeComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "outerloopcode" ---
    for thisComponent in outerloopcodeComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "outerloopcode" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    greyscale_loop = data.TrialHandler(nReps=6.0, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=[None],
        seed=None, name='greyscale_loop')
    thisExp.addLoop(greyscale_loop)  # add the loop to the experiment
    thisGreyscale_loop = greyscale_loop.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisGreyscale_loop.rgb)
    if thisGreyscale_loop != None:
        for paramName in thisGreyscale_loop:
            exec('{} = thisGreyscale_loop[paramName]'.format(paramName))
    
    for thisGreyscale_loop in greyscale_loop:
        currentLoop = greyscale_loop
        # abbreviate parameter names if possible (e.g. rgb = thisGreyscale_loop.rgb)
        if thisGreyscale_loop != None:
            for paramName in thisGreyscale_loop:
                exec('{} = thisGreyscale_loop[paramName]'.format(paramName))
        
        # --- Prepare to start Routine "oddballroutine" ---
        continueRoutine = True
        routineForceEnded = False
        # update component parameters for each repeat
        # Run 'Begin Routine' code from code
        # --- Combined Code Component in oddball routine ---
        
        
        #anikaddedmarch26 
        # This assumes you've already built a dictionary of preloaded images 
        # in an earlier routine (e.g., in your outerloop routine):
        if 'preloadedImages' in globals() and thisImage in preloadedImages:
            # Override the image component's image attribute with the preloaded image’s file path.
            # Note: The preloadedImages[thisImage] is an ImageStim that was created earlier.
            # You can set the component’s image attribute directly.
            oddball_picture.image = preloadedImages[thisImage].image
        
        #normal
        # Select the current inner loop trial index (0-based)
        current_index = inner_index
        
        # Select the image from trialImages based on the current index:
        thisImage = trialImages[current_index]
        
        # Log the image (e.g., to your data file) for later reference:
        thisExp.addData('current_image', thisImage)
        thisExp.addData('current_index', current_index)
        
        # Determine whether the current image is the oddball:
        if current_index == oddball_index:
            # Use the oddball's number from your conditions file
            image_number = ImageNumber  # Must be loaded from your outer loop conditions file
            image_type = "Oddball"
        else:
            # For greyscale images, use the current index (or another scheme)
            image_number = current_index
            image_type = "Greyscale"
        
        # Compute marker value (adjust formula as needed)
        marker_value = float(1 + float(image_number) / 1000)
        
        # Flag to prevent pushing marker multiple times (use only within this routine)
        if not hasattr(thisImage, 'flip_done'):
            oddball_picture.flip_done = False
        
        # Log the marker to the console (optional):
        print(f"Image: {thisImage}, Type: {image_type}, Marker Value: {marker_value}")
        
        # Increment the inner index for the next trial:
        inner_index += 1
        
        oddball_picture.setImage(thisImage)
        # keep track of which components have finished
        oddballroutineComponents = [oddball_picture]
        for thisComponent in oddballroutineComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "oddballroutine" ---
        while continueRoutine and routineTimer.getTime() < 0.5:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # Run 'Each Frame' code from code
            if oddball_picture.status == STARTED and not oddball_picture.flip_done:
                win.flip()  # Update the window (this happens at the end of the frame)
                outlet.push_sample([marker_value])  # Send the LSL marker after flip
                oddball_picture.flip_done = True  # Flag it to prevent resending the marker
            
            # *oddball_picture* updates
            if oddball_picture.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                oddball_picture.frameNStart = frameN  # exact frame index
                oddball_picture.tStart = t  # local t and not account for scr refresh
                oddball_picture.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(oddball_picture, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'oddball_picture.started')
                oddball_picture.setAutoDraw(True)
            if oddball_picture.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > oddball_picture.tStartRefresh + 0.5-frameTolerance:
                    # keep track of stop time/frame for later
                    oddball_picture.tStop = t  # not accounting for scr refresh
                    oddball_picture.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'oddball_picture.stopped')
                    oddball_picture.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in oddballroutineComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "oddballroutine" ---
        for thisComponent in oddballroutineComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-0.500000)
        
        # --- Prepare to start Routine "picture_delay" ---
        continueRoutine = True
        routineForceEnded = False
        # update component parameters for each repeat
        # Run 'Begin Routine' code from delay_randomization
        import random 
        
        washout_duration = random.uniform(0.3, 0.5)
        
        # keep track of which components have finished
        picture_delayComponents = [text_2]
        for thisComponent in picture_delayComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "picture_delay" ---
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *text_2* updates
            if text_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                text_2.frameNStart = frameN  # exact frame index
                text_2.tStart = t  # local t and not account for scr refresh
                text_2.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(text_2, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'text_2.started')
                text_2.setAutoDraw(True)
            if text_2.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > text_2.tStartRefresh + washout_duration-frameTolerance:
                    # keep track of stop time/frame for later
                    text_2.tStop = t  # not accounting for scr refresh
                    text_2.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'text_2.stopped')
                    text_2.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in picture_delayComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "picture_delay" ---
        for thisComponent in picture_delayComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "picture_delay" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 6.0 repeats of 'greyscale_loop'
    
    thisExp.nextEntry()
    
# completed 3.0 repeats of 'Stimulus_Trials'


# --- Prepare to start Routine "halfway_break" ---
continueRoutine = True
routineForceEnded = False
# update component parameters for each repeat
# setup some python lists for storing info about the mouse_2
mouse_2.x = []
mouse_2.y = []
mouse_2.leftButton = []
mouse_2.midButton = []
mouse_2.rightButton = []
mouse_2.time = []
mouse_2.clicked_name = []
gotValidClick = False  # until a click is received
# keep track of which components have finished
halfway_breakComponents = [text_instr_2, image_next_2, mouse_2]
for thisComponent in halfway_breakComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "halfway_break" ---
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_instr_2* updates
    if text_instr_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        text_instr_2.frameNStart = frameN  # exact frame index
        text_instr_2.tStart = t  # local t and not account for scr refresh
        text_instr_2.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(text_instr_2, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'text_instr_2.started')
        text_instr_2.setAutoDraw(True)
    
    # *image_next_2* updates
    if image_next_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        image_next_2.frameNStart = frameN  # exact frame index
        image_next_2.tStart = t  # local t and not account for scr refresh
        image_next_2.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(image_next_2, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'image_next_2.started')
        image_next_2.setAutoDraw(True)
    # *mouse_2* updates
    if mouse_2.status == NOT_STARTED and t >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        mouse_2.frameNStart = frameN  # exact frame index
        mouse_2.tStart = t  # local t and not account for scr refresh
        mouse_2.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(mouse_2, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.addData('mouse_2.started', t)
        mouse_2.status = STARTED
        mouse_2.mouseClock.reset()
        prevButtonState = mouse_2.getPressed()  # if button is down already this ISN'T a new click
    if mouse_2.status == STARTED:  # only update if started and not finished!
        buttons = mouse_2.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # check if the mouse was inside our 'clickable' objects
                gotValidClick = False
                try:
                    iter(image_next)
                    clickableList = image_next
                except:
                    clickableList = [image_next]
                for obj in clickableList:
                    if obj.contains(mouse_2):
                        gotValidClick = True
                        mouse_2.clicked_name.append(obj.name)
                x, y = mouse_2.getPos()
                mouse_2.x.append(x)
                mouse_2.y.append(y)
                buttons = mouse_2.getPressed()
                mouse_2.leftButton.append(buttons[0])
                mouse_2.midButton.append(buttons[1])
                mouse_2.rightButton.append(buttons[2])
                mouse_2.time.append(mouse_2.mouseClock.getTime())
                if gotValidClick:
                    continueRoutine = False  # abort routine on response
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in halfway_breakComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "halfway_break" ---
for thisComponent in halfway_breakComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# store data for thisExp (ExperimentHandler)
thisExp.addData('mouse_2.x', mouse_2.x)
thisExp.addData('mouse_2.y', mouse_2.y)
thisExp.addData('mouse_2.leftButton', mouse_2.leftButton)
thisExp.addData('mouse_2.midButton', mouse_2.midButton)
thisExp.addData('mouse_2.rightButton', mouse_2.rightButton)
thisExp.addData('mouse_2.time', mouse_2.time)
thisExp.addData('mouse_2.clicked_name', mouse_2.clicked_name)
thisExp.nextEntry()
# the Routine "halfway_break" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
stimulus_loop_repeat = data.TrialHandler(nReps=2.0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('ODDBALL Picture Set/Oddball Target Paths.xlsx'),
    seed=None, name='stimulus_loop_repeat')
thisExp.addLoop(stimulus_loop_repeat)  # add the loop to the experiment
thisStimulus_loop_repeat = stimulus_loop_repeat.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisStimulus_loop_repeat.rgb)
if thisStimulus_loop_repeat != None:
    for paramName in thisStimulus_loop_repeat:
        exec('{} = thisStimulus_loop_repeat[paramName]'.format(paramName))

for thisStimulus_loop_repeat in stimulus_loop_repeat:
    currentLoop = stimulus_loop_repeat
    # abbreviate parameter names if possible (e.g. rgb = thisStimulus_loop_repeat.rgb)
    if thisStimulus_loop_repeat != None:
        for paramName in thisStimulus_loop_repeat:
            exec('{} = thisStimulus_loop_repeat[paramName]'.format(paramName))
    
    # --- Prepare to start Routine "outerloopcode" ---
    continueRoutine = True
    routineForceEnded = False
    # update component parameters for each repeat
    # Run 'Begin Routine' code from code_3
    import random
    
    # For using all 19 greyscale images:
    totalGreyscale = len(greyImagesList)  # should be 19
    totalSlots = totalGreyscale + 1       # 19 + 1 = 20
    
    # Randomly choose a slot for the oddball image (0-indexed)
    oddball_index = random.randint(1, totalSlots - 1)
    
    # Create the list of images for this outer trial:
    trialImages = greyImagesList.copy()  # Make a copy of the greyscale list
    trialImages.insert(oddball_index, ImagePath)  # Insert oddball at random position
    
    # Initialize the counter for the inner loop:
    inner_index = 0
    # keep track of which components have finished
    outerloopcodeComponents = []
    for thisComponent in outerloopcodeComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "outerloopcode" ---
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in outerloopcodeComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "outerloopcode" ---
    for thisComponent in outerloopcodeComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "outerloopcode" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    greyscale_loop_repeat = data.TrialHandler(nReps=6.0, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=[None],
        seed=None, name='greyscale_loop_repeat')
    thisExp.addLoop(greyscale_loop_repeat)  # add the loop to the experiment
    thisGreyscale_loop_repeat = greyscale_loop_repeat.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisGreyscale_loop_repeat.rgb)
    if thisGreyscale_loop_repeat != None:
        for paramName in thisGreyscale_loop_repeat:
            exec('{} = thisGreyscale_loop_repeat[paramName]'.format(paramName))
    
    for thisGreyscale_loop_repeat in greyscale_loop_repeat:
        currentLoop = greyscale_loop_repeat
        # abbreviate parameter names if possible (e.g. rgb = thisGreyscale_loop_repeat.rgb)
        if thisGreyscale_loop_repeat != None:
            for paramName in thisGreyscale_loop_repeat:
                exec('{} = thisGreyscale_loop_repeat[paramName]'.format(paramName))
        
        # --- Prepare to start Routine "oddballroutine" ---
        continueRoutine = True
        routineForceEnded = False
        # update component parameters for each repeat
        # Run 'Begin Routine' code from code
        # --- Combined Code Component in oddball routine ---
        
        
        #anikaddedmarch26 
        # This assumes you've already built a dictionary of preloaded images 
        # in an earlier routine (e.g., in your outerloop routine):
        if 'preloadedImages' in globals() and thisImage in preloadedImages:
            # Override the image component's image attribute with the preloaded image’s file path.
            # Note: The preloadedImages[thisImage] is an ImageStim that was created earlier.
            # You can set the component’s image attribute directly.
            oddball_picture.image = preloadedImages[thisImage].image
        
        #normal
        # Select the current inner loop trial index (0-based)
        current_index = inner_index
        
        # Select the image from trialImages based on the current index:
        thisImage = trialImages[current_index]
        
        # Log the image (e.g., to your data file) for later reference:
        thisExp.addData('current_image', thisImage)
        thisExp.addData('current_index', current_index)
        
        # Determine whether the current image is the oddball:
        if current_index == oddball_index:
            # Use the oddball's number from your conditions file
            image_number = ImageNumber  # Must be loaded from your outer loop conditions file
            image_type = "Oddball"
        else:
            # For greyscale images, use the current index (or another scheme)
            image_number = current_index
            image_type = "Greyscale"
        
        # Compute marker value (adjust formula as needed)
        marker_value = float(1 + float(image_number) / 1000)
        
        # Flag to prevent pushing marker multiple times (use only within this routine)
        if not hasattr(thisImage, 'flip_done'):
            oddball_picture.flip_done = False
        
        # Log the marker to the console (optional):
        print(f"Image: {thisImage}, Type: {image_type}, Marker Value: {marker_value}")
        
        # Increment the inner index for the next trial:
        inner_index += 1
        
        oddball_picture.setImage(thisImage)
        # keep track of which components have finished
        oddballroutineComponents = [oddball_picture]
        for thisComponent in oddballroutineComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "oddballroutine" ---
        while continueRoutine and routineTimer.getTime() < 0.5:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            # Run 'Each Frame' code from code
            if oddball_picture.status == STARTED and not oddball_picture.flip_done:
                win.flip()  # Update the window (this happens at the end of the frame)
                outlet.push_sample([marker_value])  # Send the LSL marker after flip
                oddball_picture.flip_done = True  # Flag it to prevent resending the marker
            
            # *oddball_picture* updates
            if oddball_picture.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                oddball_picture.frameNStart = frameN  # exact frame index
                oddball_picture.tStart = t  # local t and not account for scr refresh
                oddball_picture.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(oddball_picture, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'oddball_picture.started')
                oddball_picture.setAutoDraw(True)
            if oddball_picture.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > oddball_picture.tStartRefresh + 0.5-frameTolerance:
                    # keep track of stop time/frame for later
                    oddball_picture.tStop = t  # not accounting for scr refresh
                    oddball_picture.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'oddball_picture.stopped')
                    oddball_picture.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in oddballroutineComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "oddballroutine" ---
        for thisComponent in oddballroutineComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-0.500000)
        
        # --- Prepare to start Routine "picture_delay" ---
        continueRoutine = True
        routineForceEnded = False
        # update component parameters for each repeat
        # Run 'Begin Routine' code from delay_randomization
        import random 
        
        washout_duration = random.uniform(0.3, 0.5)
        
        # keep track of which components have finished
        picture_delayComponents = [text_2]
        for thisComponent in picture_delayComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "picture_delay" ---
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *text_2* updates
            if text_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                text_2.frameNStart = frameN  # exact frame index
                text_2.tStart = t  # local t and not account for scr refresh
                text_2.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(text_2, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'text_2.started')
                text_2.setAutoDraw(True)
            if text_2.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > text_2.tStartRefresh + washout_duration-frameTolerance:
                    # keep track of stop time/frame for later
                    text_2.tStop = t  # not accounting for scr refresh
                    text_2.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'text_2.stopped')
                    text_2.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in picture_delayComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "picture_delay" ---
        for thisComponent in picture_delayComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "picture_delay" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 6.0 repeats of 'greyscale_loop_repeat'
    
    thisExp.nextEntry()
    
# completed 2.0 repeats of 'stimulus_loop_repeat'


# --- Prepare to start Routine "thanks" ---
continueRoutine = True
routineForceEnded = False
# update component parameters for each repeat
# keep track of which components have finished
thanksComponents = [text]
for thisComponent in thanksComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "thanks" ---
while continueRoutine and routineTimer.getTime() < 10.0:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text* updates
    if text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        text.frameNStart = frameN  # exact frame index
        text.tStart = t  # local t and not account for scr refresh
        text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(text, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'text.started')
        text.setAutoDraw(True)
    if text.status == STARTED:
        # is it time to stop? (based on global clock, using actual start)
        if tThisFlipGlobal > text.tStartRefresh + 10.0-frameTolerance:
            # keep track of stop time/frame for later
            text.tStop = t  # not accounting for scr refresh
            text.frameNStop = frameN  # exact frame index
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'text.stopped')
            text.setAutoDraw(False)
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in thanksComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "thanks" ---
for thisComponent in thanksComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
if routineForceEnded:
    routineTimer.reset()
else:
    routineTimer.addTime(-10.000000)

# --- End experiment ---
# Flip one final time so any remaining win.callOnFlip() 
# and win.timeOnFlip() tasks get executed before quitting
win.flip()

# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv', delim='auto')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
if eyetracker:
    eyetracker.setConnectionState(False)
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()

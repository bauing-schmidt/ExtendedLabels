Class {
	#name : #DrsBitmap,
	#superclass : #DrsShape,
	#instVars : [
		'bitmapShape',
		'baseline'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #'instance creation' }
DrsBitmap class >> exampleIcon [ 

	^ RSBitmap new form: ((Form extent: 16@16 depth: 32) fillColor: Color blue)
]

{ #category : #'instance creation' }
DrsBitmap class >> withForm: aForm [

	^ self new initializeWithForm: aForm
]

{ #category : #accessing }
DrsBitmap >> baseline [

	^ baseline ifNil: [ bitmapShape form extent y ]
]

{ #category : #accessing }
DrsBitmap >> baseline: anObject [

	baseline := anObject
]

{ #category : #accessing }
DrsBitmap >> basicTranslateBy: delta [
	
	bitmapShape basicTranslateBy: delta
]

{ #category : #accessing }
DrsBitmap >> height [

	^ bitmapShape form extent y
]

{ #category : #initialization }
DrsBitmap >> initializeWithForm: aForm [

 	bitmapShape := RSBitmap new.
	bitmapShape form: aForm.
	baseline := aForm extent y.
	
	roassalShape := (DrsComposite new shapes: { bitmapShape }).		
	self computeAssignedExtent.
]

{ #category : #accessing }
DrsBitmap >> position: aPosition [

	^ bitmapShape position: aPosition
]

{ #category : #accessing }
DrsBitmap >> width [

	^ bitmapShape form extent x
]

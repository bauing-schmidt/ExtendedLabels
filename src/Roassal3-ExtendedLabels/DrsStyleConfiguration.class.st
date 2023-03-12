Class {
	#name : #DrsStyleConfiguration,
	#superclass : #Object,
	#instVars : [
		'styles'
	],
	#category : #'Roassal3-ExtendedLabels-Styles'
}

{ #category : #accessing }
DrsStyleConfiguration >> addStyle: aStyle [ 

	styles add: aStyle
]

{ #category : #accessing }
DrsStyleConfiguration >> addStyles: drsStyles [ 

	styles add: drsStyles
]

{ #category : #accessing }
DrsStyleConfiguration >> initialize [ 

	super initialize. 

	styles := OrderedCollection new
]

{ #category : #accessing }
DrsStyleConfiguration >> styleClasses [ 

	^ self styles flatCollect: [ :aStyle | aStyle styleClasses ]
]

{ #category : #accessing }
DrsStyleConfiguration >> styles [

	^ styles
]

Extension { #name : #CSSProperty }

{ #category : #'*Roassal3-ExtendedLabels' }
CSSProperty >> asDrsStyleProperty [ 

	^ DrsStyleProperty key: propertyName value: (self convertValue: propertyString)
]

{ #category : #'*Roassal3-ExtendedLabels' }
CSSProperty >> convertValue: aString [ 

	^ self convertValue: aString  withDefault: [ 0 ]

]

{ #category : #'*Roassal3-ExtendedLabels' }
CSSProperty >> convertValue: aString  withDefault: defautlValue [

	| trimmed substrings |
	
	trimmed := propertyString trimBoth.

	(trimmed beginsWith: '#') ifTrue: [ 
		^ Color fromHexString: aString allButFirst. ].

	((trimmed beginsWith: '"') and: [ trimmed endsWith: '"' ]) ifTrue: [ 
		^ trimmed allButFirst allButLast ].
	
	substrings := trimmed substrings.
	
	substrings size <= 1 ifTrue: [ ^ NumberParser parse: trimmed onError: [ defautlValue ] ].

	^ substrings collect: [ :each | NumberParser parse: each onError: [ ^ defautlValue ] ].
	
]

{ #category : #'*Roassal3-ExtendedLabels' }
CSSProperty >> convertedString [  

	^ self convertValue: propertyString
]

{ #category : #'*Roassal3-ExtendedLabels' }
CSSProperty >> convertedStringWithDefault: defautlValue [

	^ self convertValue: propertyString withDefault: defautlValue
]

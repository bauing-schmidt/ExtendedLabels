Class {
	#name : #BaselineOfExtendedLabels,
	#superclass : #BaselineOf,
	#category : #BaselineOfExtendedLabels
}

{ #category : #baselines }
BaselineOfExtendedLabels >> baseline: spec [
   <baseline>

	spec for: #'common' do: [
		
		spec package: 'HTML'.

		spec package: 'Roassal3-ExtendedLabels'.
		spec package: 'Roassal3-ExtendedLabels-Tests'.
	]
]

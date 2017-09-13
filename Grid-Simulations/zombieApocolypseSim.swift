//
//  zombieApocolypseSim.swift
//  Grid-Simulations
//
//  Created by djchai on 9/13/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation

public class ZombieApocolypseSim: Simulation {
	var newGrid: [[Character?]] = []
	
	
	// set up the grid
	public override func setup() {
		grid = [[Character?]](repeating: [Character?](repeating: nil, count: 10), count: 10)
		
		for x in 0..<8 {
			for y in 0..<10 {
				// hold randomZeroToOne method in a constant
				let randomNum = randomZeroToOne()
				
				if randomNum <= 0.10 {
					grid[x][y] = "😱"
				} else if randomNum > 0.10 && randomNum < 0.12 {
					grid[x][y] = "☠️"
				} else if randomNum > 0.12 && randomNum < 0.13 {
					grid[x][y] = "🔥"
				}
			}
		}
	}
	
	public override func update() {
		apocolypse()
	}
	
	func apocolypse() {
		newGrid = grid
		
		for x in 0..<grid.count {
			for y in 0..<grid[x].count {
				let cell = grid[x][y]
				
				// if the cell is empty - slight chance of becomming person, zombie, or fire
				if (cell == nil) {
					// 5% chance of becoming a person
					let randomNum = randomZeroToOne()
					if (randomNum <= 0.05) {
						newGrid[x][y] = "😱"
						// 3% chance of becomming a zombie
					} else if (randomNum > 0.05 && randomNum < 0.07) {
						newGrid[x][y] = "☠️"
						// 1% chance of getting set on fire
					} else if (randomNum > 0.10 && randomNum < 0.11) {
						newGrid[x][y] = "🔥"
					}
					// if the cell is a person - check the neighbors
				} else if (cell == "😱") {
					let neighborCoords = getNeighborPositions(x: x, y: y)
					var zombieCount = 0
					var personCount = 0
					
					for neighborCord in neighborCoords {
						let neighbor = grid[neighborCord.x][neighborCord.y]
						
						if (neighbor == "☠️") {
							zombieCount += 1
							if (zombieCount > 3) {
								newGrid[x][y] = "☠️"
							}
						} else if (neighbor == "🔥" ) {
							// iterate thru the neighbors
							// find a nil cell, populate cell with "😱"
							
							newGrid[x][y] = "🔥"
						} else if (neighbor == "😱") {
							personCount += 1
							if (personCount < 3 && zombieCount < 2) {
								newGrid[x][y] = "😱"
							} //else if (personCount > 4) {
								//newGrid[x][y] = "🔥"
							//}
						}
					}
				} else if (cell == "☠️") {
					let neighborCoords = getNeighborPositions(x: x, y: y)
					var zombieCount = 0
					var personCount = 0
					
					for neighborCord in neighborCoords {
						let neighbor = grid[neighborCord.x][neighborCord.y]
						
						if (neighbor == "🔥") {
							newGrid[x][y] = "🔥"
						} else if (neighbor == "☠️") {
							zombieCount += 1
							if (zombieCount >= 2) {
								newGrid[x][y] = "☠️"
							}
						} else if (neighbor == "😱") {
							personCount += 1
							if (personCount > 3 && zombieCount < 2) {
								newGrid[x][y] = "😱"
							}
						}
					}
				} else if (cell == "🔥") {
					newGrid[x][y] = nil
				}
			}
		}
		grid = newGrid
	}
	
	func isLegalPosition(x: Int, y: Int) -> Bool {
		if (x >= 0 && y >= 0) && (x < grid.count && y < grid[x].count){
			return true
		} else {
			return false
		}
	}
	
	func getNeighborPositions(x originX: Int, y originY: Int) -> [(x: Int, y: Int)] {
		var neighbors: [(x: Int, y: Int)] = []
		
		for x in (originX-1)...(originX+1) {
			for y in (originY-1)...(originY+1) {
				if isLegalPosition(x: x, y: y) {
					if !(x == originX && y == originY) {
						neighbors.append((x, y))
					}
				}
			}
		}
		return neighbors
	}

}

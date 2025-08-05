import { describe, it, expect, beforeEach } from "vitest"

type Item = {
  owner: string
  equipped: boolean
  locked: boolean
  metadata: string
}

const mockContract = {
  admin: "STADMIN",
  paused: false,
  lastTokenId: 0,
  items: new Map<number, Item>(),

  isAdmin(caller: string) {
    return caller === this.admin
  },

  setPaused(caller: string, value: boolean) {
    if (!this.isAdmin(caller)) return { error: 100 }
    this.paused = value
    return { value }
  },

  mint(caller: string, to: string, metadata: string) {
    if (!this.isAdmin(caller)) return { error: 100 }
    if (to === "SP000000000000000000002Q6VF78") return { error: 101 }

    const tokenId = ++this.lastTokenId
    this.items.set(tokenId, {
      owner: to,
      equipped: false,
      locked: false,
      metadata
    })
    return { value: tokenId }
  },

  transfer(caller: string, tokenId: number, to: string) {
    if (this.paused) return { error: 105 }
    const item = this.items.get(tokenId)
    if (!item) return { error: 102 }
    if (item.owner !== caller) return { error: 103 }
    if (item.locked) return { error: 104 }
    if (to === "SP000000000000000000002Q6VF78") return { error: 101 }
    item.owner = to
    return { value: true }
  },

  equip(caller: string, tokenId: number) {
    if (this.paused) return { error: 105 }
    const item = this.items.get(tokenId)
    if (!item) return { error: 102 }
    if (item.owner !== caller) return { error: 103 }
    item.equipped = true
    return { value: true }
  },

  unequip(caller: string, tokenId: number) {
    if (this.paused) return { error: 105 }
    const item = this.items.get(tokenId)
    if (!item) return { error: 102 }
    if (item.owner !== caller) return { error: 103 }
    item.equipped = false
    return { value: true }
  },

  lock(caller: string, tokenId: number) {
    if (!this.isAdmin(caller)) return { error: 100 }
    const item = this.items.get(tokenId)
    if (!item) return { error: 102 }
    item.locked = true
    return { value: true }
  },

  unlock(caller: string, tokenId: number) {
    if (!this.isAdmin(caller)) return { error: 100 }
    const item = this.items.get(tokenId)
    if (!item) return { error: 102 }
    item.locked = false
    return { value: true }
  }
}

describe("Ownplay Item NFT Contract", () => {
  beforeEach(() => {
    mockContract.paused = false
    mockContract.lastTokenId = 0
    mockContract.items = new Map()
  })

  it("allows admin to mint an item", () => {
    const result = mockContract.mint("STADMIN", "STPLAYER1", "Sword of Truth")
    expect(result).toEqual({ value: 1 })
    expect(mockContract.items.get(1)?.metadata).toBe("Sword of Truth")
  })

  it("prevents non-admin from minting", () => {
    const result = mockContract.mint("STPLAYER1", "STPLAYER2", "Boots")
    expect(result).toEqual({ error: 100 })
  })

  it("allows item transfer if not locked", () => {
    mockContract.mint("STADMIN", "STPLAYER1", "Armor")
    const result = mockContract.transfer("STPLAYER1", 1, "STPLAYER2")
    expect(result).toEqual({ value: true })
    expect(mockContract.items.get(1)?.owner).toBe("STPLAYER2")
  })

  it("prevents transfer of locked items", () => {
    mockContract.mint("STADMIN", "STPLAYER1", "Locked Item")
    mockContract.lock("STADMIN", 1)
    const result = mockContract.transfer("STPLAYER1", 1, "STPLAYER2")
    expect(result).toEqual({ error: 104 })
  })

  it("allows player to equip and unequip their item", () => {
    mockContract.mint("STADMIN", "STPLAYER1", "Shield")
    mockContract.equip("STPLAYER1", 1)
    expect(mockContract.items.get(1)?.equipped).toBe(true)
    mockContract.unequip("STPLAYER1", 1)
    expect(mockContract.items.get(1)?.equipped).toBe(false)
  })

  it("pauses contract and blocks transfers", () => {
    mockContract.mint("STADMIN", "STPLAYER1", "Axe")
    mockContract.setPaused("STADMIN", true)
    const result = mockContract.transfer("STPLAYER1", 1, "STPLAYER2")
    expect(result).toEqual({ error: 105 })
  })
})

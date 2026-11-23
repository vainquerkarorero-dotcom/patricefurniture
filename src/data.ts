export type Product = {
  id: number; name: string; category: string; priceRwf: number; priceUsd: number;
  material: string; image: string; tag: string
}
export const products: Product[] = [
  { id: 1, name: 'Walnut Signature Bed', category: 'Bedroom', priceRwf: 850000, priceUsd: 650, material: 'Walnut finish', tag: 'Bestseller', image: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1000&q=85' },
  { id: 2, name: 'Heritage Dining Table', category: 'Dining', priceRwf: 620000, priceUsd: 475, material: 'Solid wood', tag: 'Crafted to order', image: 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1000&q=85' },
  { id: 3, name: 'Modern Lounge Chair', category: 'Living', priceRwf: 280000, priceUsd: 215, material: 'Wood & upholstery', tag: 'New arrival', image: 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=1000&q=85' },
  { id: 4, name: 'Classic Storage Cabinet', category: 'Storage', priceRwf: 490000, priceUsd: 375, material: 'Oak finish', tag: 'Custom options', image: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1000&q=85' }
]
export const projects = [
  { title: 'Warm Contemporary Residence', type: 'Interior design', image: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=85' },
  { title: 'Modern Timber Exterior', type: 'Exterior design', image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=85' },
  { title: 'Bespoke Kitchen Collection', type: 'Custom furniture', image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=85' }
]

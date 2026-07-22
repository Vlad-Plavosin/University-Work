import React from 'react'; // Import React
import { render } from '@testing-library/react';
import Details from './Components/Description';
import { useGlassesContext } from './context';
import '@testing-library/jest-dom/extend-expect'

jest.mock('react-router-dom', () => ({
  useLocation: jest.fn(() => ({
    state: { itemid: 1 },
  })),
}));

jest.mock('./context', () => ({
  useGlassesContext: jest.fn(() => [
    { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 'High', supplier: 'Supplier A' },
    { id: 2, count: 10, color: 'Blue', shape: 'Square', quality: 'Medium', supplier: 'Supplier B' },
  ]),
}));

describe('Details component', () => {
  test('renders details for selected glasses', () => {
    const { getByText } = render(<Details />);
    
    expect(getByText('Glasses Details')).toBeInTheDocument();
    expect(getByText('Count: 5')).toBeInTheDocument();
    expect(getByText('Color: Red')).toBeInTheDocument();
    expect(getByText('Shape: Round')).toBeInTheDocument();
    expect(getByText('Quality: High')).toBeInTheDocument();
    expect(getByText('Supplier: Supplier A')).toBeInTheDocument();
  });

  test('renders default values when no glasses are selected', () => {

    jest.spyOn(require('react-router-dom'), 'useLocation').mockReturnValueOnce({ state: {} });

    const { getByText } = render(<Details />);
    
    expect(getByText('Glasses Details')).toBeInTheDocument();
    expect(getByText(text => text.startsWith('Count:'))).toBeInTheDocument();
    expect(getByText(text => text.startsWith('Color:'))).toBeInTheDocument();
    expect(getByText(text => text.startsWith('Shape:'))).toBeInTheDocument();
    expect(getByText(text => text.startsWith('Quality:'))).toBeInTheDocument();
    expect(getByText(text => text.startsWith('Supplier:'))).toBeInTheDocument();
  });
});

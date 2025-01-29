use crate::core::project::node::Node;

pub struct NodeIterator<'a> {
  stack: Vec<&'a Node>,
}

impl<'a> NodeIterator<'a> {
  fn new(root: &'a Node) -> Self {
    Self { stack: vec![root] }
  }
}

impl<'a> Iterator for NodeIterator<'a> {
  type Item = &'a Node;

  fn next(&mut self) -> Option<Self::Item> {
    let node = self.stack.pop()?;
    if let Some(children) = &node.contents {
      for child in children.values() {
        self.stack.push(child);
      }
    }

    Some(node)
  }
}

impl<'a> IntoIterator for &'a Node {
  type Item = &'a Node;

  type IntoIter = NodeIterator<'a>;

  fn into_iter(self) -> Self::IntoIter {
    NodeIterator::new(self)
  }
}
